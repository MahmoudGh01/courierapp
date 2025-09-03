// enums.dart
// --- Mirror backend enums exactly ---
enum ServiceType { RELOCATION, FREIGHT_TRANSPORTATION }
enum TransportRequestStatus { DRAFT, PUBLISHED, ACCEPTED, IN_PROGRESS, COMPLETED, CANCELLED }

enum DismantlingType { ALL_ITEMS, SOME_ITEMS, NONE }

enum VehicleType { SEMI_TRAILER, VAN, TRUCK, PICKUP } // extend as needed
enum AccessType { LARGE_VEHICLE, LIGHT_ONLY, HEIGHT_WIDTH_RESTRICTED }
enum LoadingCapacityType { LIGHT_DUTY, MEDIUM_DUTY, HEAVY_DUTY }

enum PaymentMethod { CASH_ON_DELIVERY, BANK_TRANSFER, CARD }
enum PaymentCondition { PAYMENT_ON_RECEIPT, ADVANCE, NET30 }

// Helper: map enums to strings expected by backend (if backend expects exact names, keep .name)
String enumToString(Object e) => e.toString().split('.').last;
