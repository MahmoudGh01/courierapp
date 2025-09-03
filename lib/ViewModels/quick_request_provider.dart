import 'package:flutter/material.dart';

enum ServiceType { RELOCATION }
enum TransportRequestStatus { PUBLISHED }

class QuickRequestProvider extends ChangeNotifier {
  // Defaults required by backend
  ServiceType serviceType = ServiceType.RELOCATION;
  TransportRequestStatus status = TransportRequestStatus.PUBLISHED;

  // Origin (required)
  String originAddress = '';
  String originState = '';
  String originCity = '';
  String originPostalCode = '';
  double? originLatitude;
  double? originLongitude;

  // Destination (required)
  String destinationAddress = '';
  String destinationState = '';
  String destinationCity = '';
  String destinationPostalCode = '';
  double? destinationLatitude;
  double? destinationLongitude;

  // Meta (required/optional)
  DateTime? pickUpDate;        // required
  DateTime? deliveryDate;      // optional
  String description = '';     // required

  // ---- Update helpers ----
  void updateOrigin({
    String? address,
    String? state,
    String? city,
    String? postalCode,
    double? lat,
    double? lng,
  }) {
    if (address != null) originAddress = address;
    if (state != null) originState = state;
    if (city != null) originCity = city;
    if (postalCode != null) originPostalCode = postalCode;
    if (lat != null) originLatitude = lat;
    if (lng != null) originLongitude = lng;
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
    if (address != null) destinationAddress = address;
    if (state != null) destinationState = state;
    if (city != null) destinationCity = city;
    if (postalCode != null) destinationPostalCode = postalCode;
    if (lat != null) destinationLatitude = lat;
    if (lng != null) destinationLongitude = lng;
    notifyListeners();
  }

  void updateMeta({
    DateTime? pickup,
    DateTime? delivery,
    String? desc,
  }) {
    if (pickup != null) pickUpDate = pickup;
    if (delivery != null) deliveryDate = delivery;
    if (desc != null) description = desc;
    notifyListeners();
  }

  // ---- Validation ----
  bool isStep1Valid() {
    return originAddress.isNotEmpty &&
        originState.isNotEmpty &&
        originCity.isNotEmpty &&
        originPostalCode.isNotEmpty &&
        originLatitude != null &&
        originLongitude != null;
  }

  bool isStep2Valid() {
    return destinationAddress.isNotEmpty &&
        destinationState.isNotEmpty &&
        destinationCity.isNotEmpty &&
        destinationPostalCode.isNotEmpty &&
        destinationLatitude != null &&
        destinationLongitude != null;
  }

  bool isStep3Valid() {
    return pickUpDate != null && description.isNotEmpty;
  }

  Map<String, dynamic> toJson({required int userId}) {
    return {
      "serviceType": serviceType.name,
      "status": status.name,
      "originAddress": originAddress,
      "originState": originState,
      "originCity": originCity,
      "originPostalCode": originPostalCode,
      "originLatitude": originLatitude,
      "originLongitude": originLongitude,
      "destinationAddress": destinationAddress,
      "destinationState": destinationState,
      "destinationCity": destinationCity,
      "destinationPostalCode": destinationPostalCode,
      "destinationLatitude": destinationLatitude,
      "destinationLongitude": destinationLongitude,
      "pickUpDate": pickUpDate?.toIso8601String(),
      "deliveryDate": deliveryDate?.toIso8601String(),
      "description": description,
      "userId": userId, // if your backend binds user by id from DTO
    };
  }

  void reset() {
    serviceType = ServiceType.RELOCATION;
    status = TransportRequestStatus.PUBLISHED;

    originAddress = '';
    originState = '';
    originCity = '';
    originPostalCode = '';
    originLatitude = null;
    originLongitude = null;

    destinationAddress = '';
    destinationState = '';
    destinationCity = '';
    destinationPostalCode = '';
    destinationLatitude = null;
    destinationLongitude = null;

    pickUpDate = null;
    deliveryDate = null;
    description = '';
    notifyListeners();
  }
}
