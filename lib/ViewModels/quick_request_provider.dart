import 'package:courier_app/Models/quick_transport_request_model.dart';
import 'package:courier_app/Service/deliveries_api.dart';
import 'package:flutter/material.dart';

import '../Models/transport_request_model.dart';

enum ServiceType { RELOCATION }

enum TransportRequestStatus { PUBLISHED }

class QuickRequestProvider extends ChangeNotifier {
  final QuickTransportRequestModel _quickRequest = QuickTransportRequestModel(
      idRequest: 0,
      serviceType: ServiceType.RELOCATION.name,
      status: TransportRequestStatus.PUBLISHED.name,
      originAddress: '',
      originState: '',
      originCity: '',
      originPostalCode: '',
      originLatitude: 0.0,
      originLongitude: 0.0,
      destinationAddress: '',
      destinationState: '',
      destinationCity: '',
      destinationPostalCode: '',
      destinationLatitude: 0.0,
      destinationLongitude: 0.0,
      pickUpDate: DateTime.now(),
      description: '',
      createdAt: DateTime.now());
  // Defaults required by backend
  QuickTransportRequestModel get quickRequest => _quickRequest;

  List<QuickTransportRequestModel> _quickRequests = [];
  List<TransportRequestModel> _transportRequests = [];

  List<QuickTransportRequestModel> get quickRequests => _quickRequests;
  List<TransportRequestModel> get transportRequests => _transportRequests;

  bool _loadingQuick = false;
  bool _loadingTransport = false;

  bool get loadingQuick => _loadingQuick;
  bool get loadingTransport => _loadingTransport;

  Future<void> fetchQuickRequests(String id) async {
    _loadingQuick = true;
    notifyListeners();

    try {

      _quickRequests = await DeliveriesApi.fetchQuickRequests(id);
    } catch (e) {
      _quickRequests = [];
    }

    _loadingQuick = false;
    notifyListeners();
  }

  Future<void> fetchTransportRequests(String id) async {
    _loadingTransport = true;
    notifyListeners();

    try {
      _transportRequests = await DeliveriesApi.fetchTransportRequests(id);
    } catch (e) {
      _transportRequests = [];
    }

    _loadingTransport = false;
    notifyListeners();
  }

  // ---- Update helpers ----
  void updateOrigin({
    String? address,
    String? state,
    String? city,
    String? postalCode,
    double? lat,
    double? lng,
  }) {
    if (address != null) _quickRequest.originAddress = address;
    if (state != null) _quickRequest.originState = state;
    if (city != null) _quickRequest.originCity = city;
    if (postalCode != null) _quickRequest.originPostalCode = postalCode;
    if (lat != null) _quickRequest.originLatitude = lat;
    if (lng != null) _quickRequest.originLongitude = lng;
    notifyListeners();
  }

  void updateDestination({
    String? address,
    String? state,
    String? city,
    String? postalCode,
    double? lat,
    double? lng,
  }) {
    if (address != null) _quickRequest.destinationAddress = address;
    if (state != null) _quickRequest.destinationState = state;
    if (city != null) _quickRequest.destinationCity = city;
    if (postalCode != null) _quickRequest.destinationPostalCode = postalCode;
    if (lat != null) _quickRequest.destinationLatitude = lat;
    if (lng != null) _quickRequest.destinationLongitude = lng;
    notifyListeners();
  }

  void updateMeta({
    DateTime? pickup,
    DateTime? delivery,
    String? desc,
  }) {
    if (pickup != null) _quickRequest.pickUpDate = pickup;
    if (delivery != null) _quickRequest.deliveryDate = delivery;
    if (desc != null) _quickRequest.description = desc;
    notifyListeners();
  }

  // ---- Validation ----
  bool isStep1Valid() {
    return _quickRequest.originAddress.isNotEmpty &&
        _quickRequest.originState.isNotEmpty &&
        _quickRequest.originCity.isNotEmpty &&
        _quickRequest.originPostalCode.isNotEmpty &&
        _quickRequest.originLatitude != 0.0 &&
        _quickRequest.originLongitude != 0.0;
  }

  bool isStep2Valid() {
    return _quickRequest.destinationAddress.isNotEmpty &&
        _quickRequest.destinationState.isNotEmpty &&
        _quickRequest.destinationCity.isNotEmpty &&
        _quickRequest.destinationPostalCode.isNotEmpty &&
        _quickRequest.destinationLatitude != 0.0 &&
        _quickRequest.destinationLongitude != 0.0;
  }

  bool isStep3Valid() {
    return _quickRequest.pickUpDate != null &&
        _quickRequest.description.isNotEmpty;
  }

  void reset() {
    _quickRequest.serviceType = ServiceType.RELOCATION.name;
    _quickRequest.status = TransportRequestStatus.PUBLISHED.name;

    _quickRequest.originAddress = '';
    _quickRequest.originState = '';
    _quickRequest.originCity = '';
    _quickRequest.originPostalCode = '';
    _quickRequest.originLatitude = 0.0;
    _quickRequest.originLongitude = 0.0;

    _quickRequest.destinationAddress = '';
    _quickRequest.destinationState = '';
    _quickRequest.destinationCity = '';
    _quickRequest.destinationPostalCode = '';
    _quickRequest.destinationLatitude = 0.0;
    _quickRequest.destinationLongitude = 0.0;

    _quickRequest.pickUpDate = DateTime.now();
    _quickRequest.deliveryDate = null;
    _quickRequest.description = '';
    notifyListeners();
  }
}
