import 'dart:convert';
import 'plan_limit_model.dart';

class PlanModel {
  final int idPlan;
  final String name;
  final double price;
  final String? description;
  final String interval; // PlanInterval Enum (e.g., MONTHLY, YEARLY)
  final List<String> features;
  final bool isActive;
  final String suitedFor; // Role Enum (e.g., SHIPPER, TRANSPORTER)
  final PlanLimitModel? limits;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlanModel({
    required this.idPlan,
    required this.name,
    required this.price,
    this.description,
    required this.interval,
    this.features = const [],
    this.isActive = true,
    required this.suitedFor,
    this.limits,
    this.createdAt,
    this.updatedAt,
  });

  factory PlanModel.fromJson(Map<String, dynamic> j) {
    return PlanModel(
      idPlan: j['idPlan'] ?? 0,
      name: j['name'] ?? '',
      price: (j['price'] as num?)?.toDouble() ?? 0.0,
      description: j['description'],
      interval: j['interval'] ?? '',
      features: (j['features'] as List<dynamic>?)
          ?.map((f) => f.toString())
          .toList() ??
          [],
      isActive: j['isActive'] ?? true,
      suitedFor: j['suitedFor'] ?? 'SHIPPER',
      limits: j['limits'] != null
          ? PlanLimitModel.fromJson(j['limits'])
          : null,
      createdAt: j['createdAt'] != null
          ? DateTime.tryParse(j['createdAt'])
          : null,
      updatedAt: j['updatedAt'] != null
          ? DateTime.tryParse(j['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "idPlan": idPlan,
    "name": name,
    "price": price,
    "description": description,
    "interval": interval,
    "features": features,
    "isActive": isActive,
    "suitedFor": suitedFor,
    "limits": limits?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
