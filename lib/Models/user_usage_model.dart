class UserUsageModel {
  final int idUserUsage;
  final int transportRequestsUsed;
  final int quickTransportRequestsUsed;
  final int offersUsedToday;
  final int offersUsedThisMonth;
  final DateTime? currentMonthStart;
  final DateTime? lastDailyReset;
  final DateTime? lastMonthlyReset;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserUsageModel({
    required this.idUserUsage,
    required this.transportRequestsUsed,
    required this.quickTransportRequestsUsed,
    required this.offersUsedToday,
    required this.offersUsedThisMonth,
    this.currentMonthStart,
    this.lastDailyReset,
    this.lastMonthlyReset,
    this.createdAt,
    this.updatedAt,
  });

  factory UserUsageModel.fromJson(Map<String, dynamic> j) => UserUsageModel(
    idUserUsage: j['idUserUsage'] ?? 0,
    transportRequestsUsed: j['transportRequestsUsed'] ?? 0,
    quickTransportRequestsUsed: j['quickTransportRequestsUsed'] ?? 0,
    offersUsedToday: j['offersUsedToday'] ?? 0,
    offersUsedThisMonth: j['offersUsedThisMonth'] ?? 0,
    currentMonthStart: j['currentMonthStart'] != null
        ? DateTime.tryParse(j['currentMonthStart'])
        : null,
    lastDailyReset: j['lastDailyReset'] != null
        ? DateTime.tryParse(j['lastDailyReset'])
        : null,
    lastMonthlyReset: j['lastMonthlyReset'] != null
        ? DateTime.tryParse(j['lastMonthlyReset'])
        : null,
    createdAt: j['createdAt'] != null
        ? DateTime.tryParse(j['createdAt'])
        : null,
    updatedAt: j['updatedAt'] != null
        ? DateTime.tryParse(j['updatedAt'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "idUserUsage": idUserUsage,
    "transportRequestsUsed": transportRequestsUsed,
    "quickTransportRequestsUsed": quickTransportRequestsUsed,
    "offersUsedToday": offersUsedToday,
    "offersUsedThisMonth": offersUsedThisMonth,
    "currentMonthStart": currentMonthStart?.toIso8601String(),
    "lastDailyReset": lastDailyReset?.toIso8601String(),
    "lastMonthlyReset": lastMonthlyReset?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
