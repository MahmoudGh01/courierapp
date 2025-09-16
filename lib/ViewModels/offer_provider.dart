import 'package:flutter/material.dart';
import '../Models/offer_model.dart';
import '../Service/offer_service.dart';

class OfferProvider extends ChangeNotifier {
  List<OfferModel> _offers = [];
  List<OfferModel> get offers => _offers;

  // load offers from API
  Future<void> fetchOffers(int idRequest) async {
    _offers = await OfferService.getAllOffersByQuickRequestId(idRequest);
    notifyListeners();
  }


  // accept offer
  Future<bool> acceptOffer(int id, int idRequest) async {
    final ok = await OfferService.acceptOffer(id);
    if (ok) await fetchOffers(idRequest); // ✅ refresh with request id
    return ok;
  }

  // refuse offer
  Future<bool> refuseOffer(int id, int idRequest) async {
    final ok = await OfferService.refuseOffer(id);
    if (ok) await fetchOffers(idRequest); // ✅ refresh with request id
    return ok;
  }
}
