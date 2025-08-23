import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user.dart';
import '../utils/constants.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    idUser: 0,
    name: '',
    email: '',
    password: '',
    isActive: true,
    role: 'User',
    token: '',
    refresh: '',
    phoneNumber: '',
    image: '',
    emailVerified: null,
    googleId: '',
    facebookId: '',
    isCompany: false,
    companyName: '',
    companyRegistrationNumber: '',
  );


  User get user => _user;


  void setUser(Map<String, dynamic> userMap) {
    _user = User.fromJson(userMap);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }



  void setPasswordResetEmail(String email) {
    _user.email = email;
    notifyListeners();
  }

  Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh') ?? '';
    if (refresh.isEmpty) return false;

    try {
      final res = await http.post(
        Uri.parse('${Constants.uri}auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refresh}),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        await prefs.setString('token', body['token'] ?? '');
        await prefs.setString('refresh', body['refreshToken'] ?? '');
        return true;
      }
      return false;
    } catch (e) {
      print('Refresh token error: $e');
      return false;
    }
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';
    if (token.isEmpty) return;

    try {
      var res = await http.get(
        Uri.parse('${Constants.uri}auth/me'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        setUser(body);
        return;
      }

      if (res.statusCode == 403) {
        final ok = await refreshToken();
        if (!ok) {
          await prefs.remove('token');
          await prefs.remove('refresh');
          return;
        }
        token = prefs.getString('token') ?? '';
        res = await http.get(
          Uri.parse('${Constants.uri}auth/me'),
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        );
        if (res.statusCode == 200) {
          final body = jsonDecode(res.body);
          setUser(body['user']);
        }
      }
    } catch (e) {
      print("Fetch user data error: $e");
    }
  }

  Future<void> editUser({
    required int userId,
    required String name,
    required String email,
    String? profilePicturePath,
    String? phone,
    String? role,
    bool? isCompany,
    String? companyName,
    String? companyRegistrationNumber,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final uri = Uri.parse('${Constants.uri}users/modify-users/$userId');
      final body = {

        'name': name,
        'email': email,
        'image': profilePicturePath ?? '',
        'role': role ?? 'SHIPPER',
        'phoneNumber': phone ?? '',
        'isCompany': isCompany,
        'companyName': companyName,
        'companyRegistrationNumber': companyRegistrationNumber,
      };

      final res = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': "application/json; charset=UTF-8",
          'Authorization': 'Bearer $token',   // ✅ add token here
        },
      );

      if (res.statusCode == 200) {
        print('User updated successfully: ${res.body}');
        await fetchUserData();
      } else {
        print('Failed to update user: ${res.statusCode} → ${res.body}');
      }
    } catch (e) {
      print('Edit user error: $e');
    }
  }



}
