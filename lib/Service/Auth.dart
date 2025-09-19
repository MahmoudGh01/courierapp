import 'dart:convert';
import 'dart:io';

import 'package:courier_app/Authentication/signin_navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user.dart';
import '../Routes/routes.dart';
import '../ViewModels/userprovider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';


class AuthService extends GetxController {
  var isAuthenticated = false.obs;
  var currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    _loadAuthStatus();
  }

  Future<void> _loadAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isAuthenticated.value = prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
    required String phoneNumber,
    required bool isCompany,
    String? companyName,
    String? companyRegistrationNumber,
  }) async {
    try {
      final payload = {
        'email': email.trim(),
        'name': name.trim(),
        'password': password,
        'phoneNumber': phoneNumber.trim(),
        'isCompany': isCompany,
        // only include company fields if isCompany == true and not empty
        if (isCompany && (companyName?.trim().isNotEmpty ?? false))
          'companyName': companyName!.trim(),
        if (isCompany && (companyRegistrationNumber?.trim().isNotEmpty ?? false))
          'companyRegistrationNumber': companyRegistrationNumber!.trim(),
      };

      final res = await http.post(
        Uri.parse('${Constants.uri}auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        showSnackBar(context, 'Account created. Please check your email to verify your account.');
        navigatorKey.currentState?.pushReplacementNamed(SignInRoutes.signInRoot);
      } else {
        final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
        final msg = body['message']?.toString() ?? 'Sign-up failed (${res.statusCode})';
        showSnackBar(context, msg);
      }
    } catch (e) {
      showSnackBar(context, 'Sign-up error: $e');
    }
  }



  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
    required VoidCallback onLoginSuccess,

  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final res = await http.post(
        Uri.parse('${Constants.uri}auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final role = data['user']['role']?.toString() ?? '';
        if (role != 'SHIPPER') {
          showSnackBar(context, 'Please connect to Sheapit Delivery app.');
          return; // prevent login continuation
        }
        userProvider.setUser(data['user']);
        print(data['user']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token'] ?? '');
        await prefs.setString('refresh', data['refreshToken'] ?? ''); // NEW
        await prefs.setBool('isLoggedIn', true);

        isAuthenticated.value = true;
        onLoginSuccess();
      } else {
        final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
        final msg = body['detail']?.toString() ?? 'Login failed (${res.statusCode})';

        // Common backend message for unverified users
        if (msg.toLowerCase().contains('not verified')) {
          showSnackBar(context, 'Please verify your email before logging in.');
        } else {
          showSnackBar(context, msg);
        }
      }

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh');
    await prefs.setBool('isLoggedIn', false);

    isAuthenticated.value = false;


  }

  Future<void> otpverif({
    required BuildContext context,
    required String email,
  }) async {
    try {
      Provider.of<UserProvider>(context, listen: false)
          .setPasswordResetEmail(email);

      final response = await http.post(
        Uri.parse('${Constants.uri}/otp-verif'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () => showSnackBar(context, 'OTP email sent'),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> forgotPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      Provider.of<UserProvider>(context, listen: false)
          .setPasswordResetEmail(email);

      final response = await http.post(
        Uri.parse('${Constants.uri}/forgot_password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () => showSnackBar(context, 'Reset email sent'),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<int> verifyCode({
    required BuildContext context,
    required String code,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.uri}/verify_code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        showSnackBar(context, 'Code verified');
        return 200;
      } else {
        return 400;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return 400;
    }
  }

  Future<void> changePassword({
    required BuildContext context,
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.uri}/reset_password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'new_password': newPassword}),
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () => showSnackBar(context, 'Password changed'),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> setPassword({
    required BuildContext context,
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.uri}/set-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': newPassword}),
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () => showSnackBar(context, 'Password set'),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> sendGoogleSignInDataToBackend(
      String code,
      BuildContext context,
      ) async {
    final uri = Uri.parse('${Constants.uri}/google-sign-in');
    final platform = Platform.isAndroid ? 'android' : 'ios';

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'code': code, 'platform': platform}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(data['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('refresh', data['refresh']);
      await prefs.setBool('isLoggedIn', true);

      isAuthenticated.value = true;
    } else {
      print('Google sign-in failed: ${response.statusCode}');
    }
  }

  Future<void> sendFBSignInDataToBackend(
      String token,
      BuildContext context,
      ) async {
    final endpoint = Platform.isAndroid
        ? "/facebook-sign-in-android"
        : "/facebook-sign-in";
    final uri = Uri.parse('${Constants.uri}$endpoint');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(data['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('refresh', data['refresh']);
      await prefs.setBool('isLoggedIn', true);

      isAuthenticated.value = true;
    } else {
      print('Facebook sign-in failed: ${response.statusCode}');
    }
  }

  Future<void> sendPhoneSignInDataToBackend(
      String phoneNumber,
      BuildContext context,
      ) async {
    final uri = Uri.parse('${Constants.uri}/phone-sign-in');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(data['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('refresh', data['refresh']);
      await prefs.setBool('isLoggedIn', true);

      isAuthenticated.value = true;
    } else {
      print('Phone sign-in failed: ${response.statusCode}');
    }
  }
}
