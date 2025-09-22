import 'package:courier_app/Models/driver_model.dart';
import 'package:courier_app/Models/quick_transport_request_model.dart';
import 'package:courier_app/Models/transport_request_model.dart';
import 'package:courier_app/Models/user.dart';

import 'shipment_timeline.dart';

enum ShipmentStatus {
  CONFIRMED,
  DISPATCHED,
  IN_TRANSIT,
  DELIVERED,
  COMPLETED,
  FAILED,
}

class Shipment {
  final int idShipment;
  final ShipmentStatus status;

  // Relations (IDs only to avoid nesting heavy objects)
  final TransportRequestModel? transportRequest;
  final QuickTransportRequestModel? quickTransportRequest;
  final DriverModel driver;
  final User user;

  final List<ShipmentTimeline> timeline;

  final DateTime createdAt;
  final DateTime? updatedAt;

  Shipment({
    required this.idShipment,
    required this.status,
    this.transportRequest,
    this.quickTransportRequest,
    required this.driver,
    required this.user,
    required this.timeline,
    required this.createdAt,
    this.updatedAt,
  });

  // --- JSON Factory ---
  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      idShipment: json['idShipment'],
      status: ShipmentStatus.values.firstWhere(
            (e) => e.toString().split('.').last == json['status'],
      ),
      transportRequest: json['transportRequest']?['idTransportRequest'] != null
          ? TransportRequestModel.fromJson(json['transportRequest'])
          : null,
      quickTransportRequest: json['quickRequest']?['idQuickTransportRequest'] != null
          ? QuickTransportRequestModel.fromJson(json['quickRequest'])
          : null,
      driver: json['driver'] != null
          ? DriverModel.fromJson(json['driver'])
          : throw Exception('Driver data is required'),
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : throw Exception('User data is required'),
      timeline: (json['timeline'] as List<dynamic>? ?? [])
          .map((e) => ShipmentTimeline.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // --- JSON Serializer ---

}
