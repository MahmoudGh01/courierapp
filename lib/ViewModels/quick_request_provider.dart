import 'package:flutter/material.dart';

enum ServiceType { RELOCATION, FREIGHT_TRANSPORTATION }
enum TransportRequestStatus { DRAFT, PUBLISHED, IN_NEGOTIATION, OFFER_ACCEPTED, CANCELLED }

class QuickRequestProvider extends ChangeNotifier {
  // Step 1: Origin
  String originAddress = '';
  String originState = '';
  String originCity = '';
  String originPostalCode = '';
  double? originLatitude;
  double? originLongitude;

  // Step 2: Destination
  String destinationAddress = '';
  String destinationState = '';
  String destinationCity = '';
  String destinationPostalCode = '';
  double? destinationLatitude;
  double? destinationLongitude;

  // Step 3: Additional info
  DateTime? pickUpDate;
  DateTime? deliveryDate;
  String description = '';
  ServiceType serviceType = ServiceType.RELOCATION;
  TransportRequestStatus status = TransportRequestStatus.PUBLISHED;

  // Optional UI/form extras (not in backend)
  bool isFragile = false;
  int selectedCourierTypeIndex = 0;
  double weight = 5.0;
  double height = 0;
  double width = 0;
  double length = 0;

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
    ServiceType? service,
    TransportRequestStatus? st,
    bool? fragile,
    int? courierTypeIndex,
    double? w,
    double? h,
    double? d,
    double? l,
  }) {
    if (pickup != null) pickUpDate = pickup;
    if (delivery != null) deliveryDate = delivery;
    if (desc != null) description = desc;
    if (service != null) serviceType = service;
    if (st != null) status = st;
    if (fragile != null) isFragile = fragile;
    if (courierTypeIndex != null) selectedCourierTypeIndex = courierTypeIndex;
    if (w != null) weight = w;
    if (h != null) height = h;
    if (d != null) width = d;
    if (l != null) length = l;
    notifyListeners();
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
      "userId": userId, // if your backend expects this in DTO (otherwise remove)
    };
  }

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
    return description.isNotEmpty && pickUpDate != null;
  }

  void reset() {
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
    serviceType = ServiceType.RELOCATION;
    status = TransportRequestStatus.PUBLISHED;

    isFragile = false;
    selectedCourierTypeIndex = 0;
    weight = 5.0;
    height = 0;
    width = 0;
    length = 0;
    notifyListeners();
  }
}
