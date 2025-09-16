import 'dart:convert';
import 'user.dart';

class DriverModel {
  int idDriver;
  String licenseNumber;
  DateTime licenseExpiryDate;
  String vehicleType; // map enum VehicleType to string
  int yearsOfExperience;

  User? user;

  DateTime createdAt;
  DateTime? updatedAt;

  DriverModel({
    required this.idDriver,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.vehicleType,
    required this.yearsOfExperience,
    this.user,
    required this.createdAt,
    this.updatedAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      idDriver: json['idDriver'] ?? 0,
      licenseNumber: json['licenseNumber'] ?? '',
      licenseExpiryDate: DateTime.tryParse(json['licenseExpiryDate'] ?? '') ?? DateTime.now(),
      vehicleType: json['vehicleType'] ?? '',
      yearsOfExperience: json['yearsOfExperience'] ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idDriver": idDriver,
      "licenseNumber": licenseNumber,
      "licenseExpiryDate": licenseExpiryDate.toIso8601String(),
      "vehicleType": vehicleType,
      "yearsOfExperience": yearsOfExperience,
      "user": user?.toMap(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }

  String toRawJson() => json.encode(toJson());
}
