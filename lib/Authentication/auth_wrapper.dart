// lib/Authentication/auth_wrapper.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Authentication/signin_navigator.dart';
import '../Routes/routes.dart';
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
      setState(() { _loading = false; _loggedIn = false; });
      return;
    }

    final ok = await _tryPingWithAutoRefresh();
    setState(() {
      _loading = false;
      _loggedIn = ok;
    });
  }

  Future<bool> _tryPingWithAutoRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    // Try a protected endpoint (e.g. /auth/me)
    var res = await http.get(
      Uri.parse('${Constants.uri}auth/me'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) return true;

    if (res.statusCode == 403) {
      final refreshed = await _refreshTokens();
      if (!refreshed) return false;

      token = prefs.getString('token') ?? '';
      res = await http.get(
        Uri.parse('${Constants.uri}auth/me'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );
      return res.statusCode == 200;
    }

    return false;
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
      final body = jsonDecode(res.body);
      await prefs.setString('token', body['token'] ?? '');
      await prefs.setString('refresh', body['refreshToken'] ?? '');
      await prefs.setBool('isLoggedIn', true);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ✅ When logged in, push to the named home route (a String),
    // not a Widget in a builder.
    if (_loggedIn) {
      return const _GotoHome(); // pushes PageRoutes.bottomNavigation
    }

    return const SignInNavigator();
  }
}

// A tiny helper widget that navigates once and shows a loader meanwhile.
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
