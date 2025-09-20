// enums.dart
// --- Mirror backend enums exactly ---
enum ServiceType { RELOCATION, FREIGHT_TRANSPORTATION }

enum TransportRequestStatus {
  DRAFT,
  PUBLISHED,
  ACCEPTED,
  IN_PROGRESS,
  COMPLETED,
  CANCELLED
}

enum DismantlingType { ALL, PARTIAL }

enum VehicleType {
  OTHER,
  SEMI_TRAILER,
  VAN,
  MEDIUM_TRUCK,
  LIGHT_TRUCK,
  TANK_TRUCK,
  REFRIGERATED_TRUCK,
  LIGHT_UTILITY_VEHICLE,
  ANY
} // extend as needed

enum AccessType {
  LARGE_VEHICLE_ACCESS,
  LIGHT_VEHICLE_ONLY,
  HEIGHT_WIDTH_RESTRICTIONS
}

enum LoadingCapacityType { LIGHT_DUTY, MEDIUM_DUTY, HEAVY_DUTY }

enum PaymentMethod {
  CREDIT_CARD_ON_DELIVERY,
  BANK_TRANSFER,
  CASH_ON_DELIVERY,
  CHECK
}

enum PaymentCondition {
  ADVANCE_PAYMENT,
  PAYMENT_ON_RECEIPT,
  INSTALLMENT_PAYMENT,
  OTHER_TERMS
}
enum LoadingType {
  FULL_CONTAINER,
  PARTIAL
}
enum MerchandiseType {
  GENERAL_GOODS,
  REFRIGERATED_PRODUCTS,
  HAZARDOUS_MATERIALS,
  FRAGILE_GOODS,
  LIQUIDS,
  GAS,
  CHEMICALS,
  FOOD,
  OTHER
}

enum PalletType { EUROPEAN, STANDARD, MINI }

// Helper: map enums to strings expected by backend (if backend expects exact names, keep .name)
String enumToString(Object e) => e.toString().split('.').last;

T? enumFromString<T>(List<T> values, String? value) {
  if (value == null) return null;
  try {
    return values.firstWhere(
      (v) => enumToString(v as Object).toLowerCase() == value.toLowerCase(),
    );
  } catch (_) {
    return null; // no match
  }
}
