// offer_service.dart
import 'dart:convert';

import 'package:courier_app/Models/offer_model.dart';

import '../utils/http_client.dart';

class OfferService {
  static Future<bool> acceptOffer(int idOffer) async {
    final res = await HttpClient.put("Offer/accept-offer/$idOffer", {});
    return res.statusCode == 200;
  }

  static Future<bool> refuseOffer(int idOffer) async {
    final res = await HttpClient.put("Offer/refuse-offer/$idOffer", {});
    return res.statusCode == 200;
  }

  static Future<List<OfferModel>> getAllOffersByQuickRequestId(int idRequest) async {
    final res = await HttpClient.get("QuickTransportRequest/retrieve-QuickTransportRequest/$idRequest");

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      // extract the offers list
      final offersJson = data['offers'] as List<dynamic>? ?? [];

      return offersJson.map((j) => OfferModel.fromJson(j)).toList();
    }

    return [];
  }


}
