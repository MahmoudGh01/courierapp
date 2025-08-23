// lib/Authentication/auth_wrapper.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Authentication/signin_navigator.dart';
import '../Routes/routes.dart';
import '../ViewModels/userprovider.dart';
import '../utils/constants.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _loading = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final refresh = prefs.getString('refresh') ?? '';

    if (token.isEmpty && refresh.isEmpty) {
      setState(() {
        _loading = false;
        _loggedIn = false;
      });
      return;
    }

    final ok = await _hydrateUserWithAutoRefresh();
    setState(() {
      _loading = false;
      _loggedIn = ok;
    });
  }

  Future<bool> _hydrateUserWithAutoRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var token = prefs.getString('token') ?? '';

    // 1) Try with current access token
    var res = await http.get(
      Uri.parse('${Constants.uri}auth/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      final body = _safeJson(res.body);
      _setUserFromMeResponse(userProvider, body);
      return true;
    }

    // 2) If unauthorized/expired → refresh then retry once
    if (res.statusCode == 401 || res.statusCode == 403) {
      final refreshed = await _refreshTokens();
      if (!refreshed) {
        await _clearTokens();
        return false;
      }

      token = prefs.getString('token') ?? '';
      res = await http.get(
        Uri.parse('${Constants.uri}auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final body = _safeJson(res.body);
        _setUserFromMeResponse(userProvider, body);
        return true;
      }
    }

    // 3) Any other failure → treat as not logged in
    return false;
  }

  void _setUserFromMeResponse(UserProvider userProvider, Map<String, dynamic>? body) {
    if (body == null) return;
    // Your provider sometimes expects a raw user, sometimes body['user'].
    // Support both shapes safely:
    if (body['user'] is Map<String, dynamic>) {
      userProvider.setUser(body['user'] as Map<String, dynamic>);
    } else {
      userProvider.setUser(body);
    }
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh');
    await prefs.setBool('isLoggedIn', false);
  }

  Future<bool> _refreshTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh') ?? '';
    if (refresh.isEmpty) return false;

    final res = await http.post(
      Uri.parse('${Constants.uri}auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refresh}),
    );

    if (res.statusCode == 200) {
      final body = _safeJson(res.body);
      await prefs.setString('token', body?['token'] ?? '');
      await prefs.setString('refresh', body?['refreshToken'] ?? '');
      await prefs.setBool('isLoggedIn', true);
      return true;
    }
    return false;
  }

  Map<String, dynamic>? _safeJson(String data) {
    try {
      final decoded = jsonDecode(data);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loggedIn) {
      return const _GotoHome(); // pushes PageRoutes.bottomNavigation
    }

    return const SignInNavigator();
  }
}

// Navigates once to the home named route after auth succeeds
class _GotoHome extends StatelessWidget {
  const _GotoHome({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(PageRoutes.bottomNavigation);
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
