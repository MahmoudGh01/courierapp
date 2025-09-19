// lib/models/quick_transport_request_model.dart
import 'package:courier_app/Models/offer_model.dart';

class QuickTransportRequestModel {
  int idRequest;
  String serviceType;
  String status;

  String originAddress;
  String originState;
  String originCity;
  String originPostalCode;
  double originLatitude;
  double originLongitude;

  String destinationAddress;
  String destinationState;
  String destinationCity;
  String destinationPostalCode;
  double destinationLatitude;
  double destinationLongitude;

  DateTime pickUpDate;
  DateTime? deliveryDate;
  String description;
  List<OfferModel>? offers;
  int? userId;

  DateTime createdAt;
  DateTime? updatedAt;

  QuickTransportRequestModel(
      {required this.idRequest,
      required this.serviceType,
      required this.status,
      required this.originAddress,
      required this.originState,
      required this.originCity,
      required this.originPostalCode,
      required this.originLatitude,
      required this.originLongitude,
      required this.destinationAddress,
      required this.destinationState,
      required this.destinationCity,
      required this.destinationPostalCode,
      required this.destinationLatitude,
      required this.destinationLongitude,
      required this.pickUpDate,
      this.deliveryDate,
      required this.description,
      this.userId,
      required this.createdAt,
      this.updatedAt,
      this.offers});

  factory QuickTransportRequestModel.fromJson(Map<String, dynamic> j) {
    return QuickTransportRequestModel(
      idRequest: j['idQuickTransportRequest'] ?? 0,
      serviceType: j['serviceType'] ?? '',
      status: j['status'] ?? '',
      originAddress: j['originAddress'] ?? '',
      originState: j['originState'] ?? '',
      originCity: j['originCity'] ?? '',
      originPostalCode: j['originPostalCode'] ?? '',
      originLatitude: (j['originLatitude'] ?? 0).toDouble(),
      originLongitude: (j['originLongitude'] ?? 0).toDouble(),
      destinationAddress: j['destinationAddress'] ?? '',
      destinationState: j['destinationState'] ?? '',
      destinationCity: j['destinationCity'] ?? '',
      destinationPostalCode: j['destinationPostalCode'] ?? '',
      destinationLatitude: (j['destinationLatitude'] ?? 0).toDouble(),
      destinationLongitude: (j['destinationLongitude'] ?? 0).toDouble(),
      pickUpDate: DateTime.parse(j['pickUpDate']),
      deliveryDate: j['deliveryDate'] != null
          ? DateTime.tryParse(j['deliveryDate'])
          : null,
      description: j['description'] ?? '',
      offers: j['offers'] != null
          ? (j['offers'] as List<dynamic>)
              .map((offer) => OfferModel.fromJson(offer))
              .toList()
          : null,
      userId: j['user']?['idUser'],
      createdAt: DateTime.parse(j['createdAt']),
      updatedAt:
          j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson({required int userId}) {
    return {
      "serviceType": this.serviceType,
      "status": this.status,
      "originAddress": this.originAddress,
      "originState": this.originState,
      "originCity": this.originCity,
      "originPostalCode": this.originPostalCode,
      "originLatitude": this.originLatitude,
      "originLongitude": this.originLongitude,
      "destinationAddress": this.destinationAddress,
      "destinationState": this.destinationState,
      "destinationCity": this.destinationCity,
      "destinationPostalCode": this.destinationPostalCode,
      "destinationLatitude": this.destinationLatitude,
      "destinationLongitude": this.destinationLongitude,
      "pickUpDate": this.pickUpDate?.toIso8601String(),
      "deliveryDate": this.deliveryDate?.toIso8601String(),
      "description": this.description,
      "user": {"idUser": userId}
    };
  }
}
