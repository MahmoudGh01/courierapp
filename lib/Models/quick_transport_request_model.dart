// lib/models/quick_transport_request_model.dart
import 'package:courier_app/Models/offer_model.dart';

class QuickTransportRequestModel {
  final int idRequest;
  final String serviceType;
  final String status;

  final String originAddress;
  final String originState;
  final String originCity;
  final String originPostalCode;
  final double originLatitude;
  final double originLongitude;

  final String destinationAddress;
  final String destinationState;
  final String destinationCity;
  final String destinationPostalCode;
  final double destinationLatitude;
  final double destinationLongitude;

  final DateTime pickUpDate;
  final DateTime? deliveryDate;
  final String description;
  final List<OfferModel>? offers;
  final int? userId;

  final DateTime createdAt;
  final DateTime? updatedAt;

  QuickTransportRequestModel({
    required this.idRequest,
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
    this.offers

  });

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
      deliveryDate: j['deliveryDate'] != null ? DateTime.tryParse(j['deliveryDate']) : null,
      description: j['description'] ?? '',
      offers: j['offers'] != null
          ? (j['offers'] as List<dynamic>)
              .map((offer) => OfferModel.fromJson(offer))
              .toList()
          : null,
      userId: j['user']?['idUser'],
      createdAt: DateTime.parse(j['createdAt']),
      updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
    );
  }

}
