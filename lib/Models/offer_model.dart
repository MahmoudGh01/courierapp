import 'dart:convert';
import 'driver_model.dart';

class OfferModel {
  int idOffer;
  double price;
  String status; // OfferStatus enum → string
  String? additionalInformation;

  DriverModel? driver;

  DateTime createdAt;
  DateTime? updatedAt;

  OfferModel({
    required this.idOffer,
    required this.price,
    required this.status,
    this.additionalInformation,
    this.driver,
    required this.createdAt,
    this.updatedAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      idOffer: json['idOffer'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'PENDING',
      additionalInformation: json['additionalInformation'],
      driver: json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idOffer": idOffer,
      "price": price,
      "status": status,
      "additionalInformation": additionalInformation,
      "driver": driver?.toJson(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }

  String toRawJson() => json.encode(toJson());
}
