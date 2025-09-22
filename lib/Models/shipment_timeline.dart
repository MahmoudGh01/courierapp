enum ShipmentTimelineType {
  CREATED,
  CONFIRMED,
  DISPATCHED,
  IN_TRANSIT,
  DELIVERED,
  COMPLETED,
  FAILED,
}

class ShipmentTimeline {
  final int idShipmentTimeline;
  final ShipmentTimelineType type;
  final DateTime dateTime;
  final String? title;
  final String message;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ShipmentTimeline({
    required this.idShipmentTimeline,
    required this.type,
    required this.dateTime,
    this.title,
    required this.message,
    required this.createdAt,
    this.updatedAt,
  });

  // --- JSON Factory ---
  factory ShipmentTimeline.fromJson(Map<String, dynamic> json) {
    return ShipmentTimeline(
      idShipmentTimeline: json['idShipmentTimeline'],
      type: ShipmentTimelineType.values.firstWhere(
            (e) => e.toString().split('.').last == json['type'],
      ),
      dateTime: DateTime.parse(json['dateTime']),
      title: json['title'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // --- JSON Serializer ---
  Map<String, dynamic> toJson() {
    return {
      'idShipmentTimeline': idShipmentTimeline,
      'type': type.toString().split('.').last,
      'dateTime': dateTime.toIso8601String(),
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
