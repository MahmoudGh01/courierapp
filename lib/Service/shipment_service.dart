import 'dart:convert';
import 'package:courier_app/utils/http_client.dart';

import '../Models/shipment_model.dart';
import '../utils/constants.dart';

class ShipmentService {
  static Future<List<Shipment>> fetchShipments() async {
    final res = await HttpClient.get("Shipment/retrieve-all-Shipments");
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Shipment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load shipments: ${res.body}');
    }
  }

  static Future<Shipment> fetchShipmentById(int id) async {
    final res = await HttpClient.get("Shipment/retrieve-Shipment/$id");
    if (res.statusCode == 200) {
      return Shipment.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load shipment: ${res.body}');
    }
  }
}
