// lib/service/deliveries_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/quick_transport_request_model.dart';
import '../Models/transport_request_model.dart';
import '../utils/constants.dart';

class DeliveriesApi {
  static Future<List<QuickTransportRequestModel>> fetchQuickRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final token  = prefs.getString('token') ?? '';

    final uri = Uri.parse('${Constants.uri}QuickTransportRequest/retrieve-all-QuickTransportRequests');
    final res = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => QuickTransportRequestModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<TransportRequestModel>> fetchTransportRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final token  = prefs.getString('token') ?? '';

    final uri = Uri.parse('${Constants.uri}TransportRequest/retrieve-all-TransportRequests');
    final res = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      // Reuse the same minimal mapping (adjust fields if different)
      return data.map((e) => TransportRequestModel.fromJson(e)).toList();
    }
    return [];
  }
}

