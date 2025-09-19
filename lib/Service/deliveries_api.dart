// lib/service/deliveries_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/quick_transport_request_model.dart';
import '../Models/transport_request_model.dart';
import '../utils/constants.dart';
import '../utils/http_client.dart';

class DeliveriesApi {
  static Future<List<QuickTransportRequestModel>> fetchQuickRequests(String id) async {

    final res = await HttpClient.get("QuickTransportRequest/retrieve-all-QuickTransportRequests/user/${id}");

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => QuickTransportRequestModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<TransportRequestModel>> fetchTransportRequests(String id) async {
    final res = await HttpClient.get("TransportRequest/retrieve-all-TransportRequests/user/${id}");


    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      // Reuse the same minimal mapping (adjust fields if different)
      return data.map((e) => TransportRequestModel.fromJson(e)).toList();
    }
    return [];
  }
}

