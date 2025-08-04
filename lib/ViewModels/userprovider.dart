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
    final refreshToken = prefs.getString('refresh');
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('${Constants.uri}/refreshToken'),
        headers: {
          'Content-Type': "application/json; charset=UTF-8",
          'Authorization': "Bearer $refreshToken",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final newAccessToken = body['access_token'];
        await prefs.setString('token', newAccessToken);
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
    final token = prefs.getString('token');

    if (token == null) {
      await prefs.setString('token', '');
      return;
    }

    try {
      final tokenRes = await http.get(
        Uri.parse('${Constants.uri}/tokenIsValid'),
        headers: {
          'Content-Type': "application/json; charset=UTF-8",
          'Authorization': "Bearer $token",
        },
      );

      final body = jsonDecode(tokenRes.body);

      if (tokenRes.statusCode == 200 && body['valid'] == true) {
        await prefs.setString('token', token);
        setUser(body);
      } else if ([401, 422, 500].contains(tokenRes.statusCode) || body['valid'] == false) {
        final refreshed = await refreshToken();
        if (refreshed) {
          await fetchUserData();
        } else {
          await prefs.remove('token');
          print("Token invalid and refresh failed. User must log in again.");
        }
      } else {
        print("Unexpected error: ${body['message']}");
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
      final uri = Uri.parse('${Constants.uri}/edit-user/$userId');
      final body = {
        'name': name,
        'email': email,
        'image': profilePicturePath ?? '',
        'phoneNumber': phone ?? '',
        'role': role ?? 'User',
        'isCompany': isCompany,
        'companyName': companyName,
        'companyRegistrationNumber': companyRegistrationNumber,
      };

      final res = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': "application/json; charset=UTF-8",
        },
      );

      if (res.statusCode == 200) {
        await fetchUserData();
      } else {
        print('Failed to update user: ${res.statusCode}');
      }
    } catch (e) {
      print('Edit user error: $e');
    }
  }


}
