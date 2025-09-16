// lib/utils/http_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class HttpClient {
  static String baseUrl = Constants.uri;
  static const String refreshEndpoint = "auth/refresh"; // adjust to your backend
  static http.Client _client = http.Client();

  // ---- GET ----
  static Future<http.Response> get(String endpoint) async {
    return _sendWithAuth(() async {
      return await _client.get(
        Uri.parse(baseUrl + endpoint),
        headers: await _headers(),
      );
    });
  }

  // ---- POST ----
  static Future<http.Response> post(String endpoint, dynamic body) async {
    return _sendWithAuth(() async {
      return await _client.post(
        Uri.parse(baseUrl + endpoint),
        headers: await _headers(),
        body: jsonEncode(body),
      );
    });
  }

  // ---- PUT ----
  static Future<http.Response> put(String endpoint, dynamic body) async {
    return _sendWithAuth(() async {
      return await _client.put(
        Uri.parse(baseUrl + endpoint),
        headers: await _headers(),
        body: jsonEncode(body),
      );
    });
  }

  // ---- DELETE ----
  static Future<http.Response> delete(String endpoint) async {
    return _sendWithAuth(() async {
      return await _client.delete(
        Uri.parse(baseUrl + endpoint),
        headers: await _headers(),
      );
    });
  }

  // ---- Private Helpers ----
  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    return {
      "Content-Type": "application/json",
      if (token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  static Future<http.Response> _sendWithAuth(
      Future<http.Response> Function() requestFn) async {
    var response = await requestFn();

    if (response.statusCode == 401 || response.statusCode == 403) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        response = await requestFn(); // retry once with new token
      } else {
        await _clearTokens();
      }
    }
    return response;
  }

  static Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString("refresh") ?? "";

    if (refresh.isEmpty) return false;

    final res = await _client.post(
      Uri.parse(baseUrl + refreshEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refresh}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final newToken = data["token"];
      final newRefresh = data["refreshToken"]; // 🔑 match backend naming

      if (newToken != null) {
        await prefs.setString("token", newToken);
      }
      if (newRefresh != null) {
        await prefs.setString("refresh", newRefresh);
      }
      await prefs.setBool("isLoggedIn", true);
      return true;
    }
    return false;
  }

  static Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("refresh");
    await prefs.setBool("isLoggedIn", false);
  }
}
