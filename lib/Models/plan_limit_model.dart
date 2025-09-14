class PlanLimitModel {
  final int idPlanLimit;
  final int transportRequestsPerMonth;
  final int quickTransportRequestsPerMonth;
  final int offersPerDay;
  final int offersPerMonth;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlanLimitModel({
    required this.idPlanLimit,
    required this.transportRequestsPerMonth,
    required this.quickTransportRequestsPerMonth,
    required this.offersPerDay,
    required this.offersPerMonth,
    this.createdAt,
    this.updatedAt,
  });

  factory PlanLimitModel.fromJson(Map<String, dynamic> j) => PlanLimitModel(
    idPlanLimit: j['idPlanLimit'] ?? 0,
    transportRequestsPerMonth: j['transportRequestsPerMonth'] ?? 0,
    quickTransportRequestsPerMonth: j['quickTransportRequestsPerMonth'] ?? 0,
    offersPerDay: j['offersPerDay'] ?? 0,
    offersPerMonth: j['offersPerMonth'] ?? 0,
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idPlanLimit": idPlanLimit,
    "transportRequestsPerMonth": transportRequestsPerMonth,
    "quickTransportRequestsPerMonth": quickTransportRequestsPerMonth,
    "offersPerDay": offersPerDay,
    "offersPerMonth": offersPerMonth,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
