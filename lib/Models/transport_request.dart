// transport_request.dart
import 'enums.dart';
import 'merchandise_item.dart';

class TransportRequestDTO {
  // Step 1
  ServiceType serviceType = ServiceType.RELOCATION;

  // Step 2
  TransportRequestStatus status = TransportRequestStatus.PUBLISHED;
  String originAddress = '';
  String originState = '';
  String originCity = '';
  String originPostalCode = '';
  double? originLatitude;
  double? originLongitude;

  String destinationAddress = '';
  String destinationState = '';
  String destinationCity = '';
  String destinationPostalCode = '';
  double? destinationLatitude;
  double? destinationLongitude;

  DateTime? pickUpDate;
  DateTime? deliveryDate;
  String? pickUpTime;    // "HH:mm"
  String? deliveryTime;  // "HH:mm"
  int? pickUpFlexibilityInDays;
  int? pickUpFlexibilityInHours;
  int? deliveryFlexibilityInDays;
  int? deliveryFlexibilityInHours;

  // dismantling/packaging
  bool? isDismantlingRequired;
  DismantlingType? dismantlingType;
  int? numberOfPiecesToDesmantle;

  int? departureFloor;
  int? arrivalFloor;
  bool? isElevatorAvailableForDeparture;
  bool? isElevatorAvailableForArrival;

  // Step 4
  VehicleType vehicleType = VehicleType.SEMI_TRAILER;
  AccessType accessType = AccessType.LARGE_VEHICLE;
  LoadingCapacityType loadingCapacity = LoadingCapacityType.MEDIUM_DUTY;
  double? maxWidth;
  double? maxHeight;

  // Step 5
  PaymentMethod paymentMethod = PaymentMethod.CASH_ON_DELIVERY;
  PaymentCondition paymentCondition = PaymentCondition.PAYMENT_ON_RECEIPT;
  String? otherTerms;

  // Step 3
  List<MerchandiseItem> items = []; // Flattened items (derive totals)
  String? merchandiseType;          // optional high-level type

  // Step 6
  List<String> documentPaths = [];  // local paths to upload (PDF/JPG/PNG ≤4MB)
  String? additionalInstructions;

  // Step 7 - computed
  double get totalWeightKg => items.fold(0.0, (s, i) => s + (i.weightKg));
  double get totalVolumeM3 => items.fold(0.0, (s, i) => s + i.volumeM3);

  Map<String, dynamic> toJson() => {
    'serviceType': enumToString(serviceType),
    'status': enumToString(status),

    'originAddress': originAddress,
    'originState': originState,
    'originCity': originCity,
    'originPostalCode': originPostalCode,
    'originLatitude': originLatitude,
    'originLongitude': originLongitude,

    'destinationAddress': destinationAddress,
    'destinationState': destinationState,
    'destinationCity': destinationCity,
    'destinationPostalCode': destinationPostalCode,
    'destinationLatitude': destinationLatitude,
    'destinationLongitude': destinationLongitude,

    'pickUpDate': pickUpDate?.toIso8601String(),
    'deliveryDate': deliveryDate?.toIso8601String(),
    'pickUpTime': pickUpTime,
    'deliveryTime': deliveryTime,

    'pickUpFlexibilityInDays': pickUpFlexibilityInDays,
    'pickUpFlexibilityInHours': pickUpFlexibilityInHours,
    'deliveryFlexibilityInDays': deliveryFlexibilityInDays,
    'deliveryFlexibilityInHours': deliveryFlexibilityInHours,

    'isDismantlingRequired': isDismantlingRequired,
    'dismantlingType': dismantlingType == null ? null : enumToString(dismantlingType!),
    'numberOfPiecesToDesmantle': numberOfPiecesToDesmantle,

    'departureFloor': departureFloor,
    'arrivalFloor': arrivalFloor,
    'isElevatorAvailableForDeparture': isElevatorAvailableForDeparture,
    'isElevatorAvailableForArrival': isElevatorAvailableForArrival,

    'vehicleType': enumToString(vehicleType),
    'accessType': enumToString(accessType),
    'loadingCapacity': enumToString(loadingCapacity),
    'maxWidth': maxWidth,
    'maxHeight': maxHeight,

    'paymentMethod': enumToString(paymentMethod),
    'paymentCondition': enumToString(paymentCondition),
    'otherTerms': otherTerms,

    'merchandise': {
      'items': items.map((e) => e.toJson()).toList(),
      'totalWeightKg': totalWeightKg,
      'totalVolumeM3': totalVolumeM3,
      'type': merchandiseType,
    },

    'documents': documentPaths.map((p) => {'path': p}).toList(),
    'additionalInstructions': additionalInstructions,
  };
}
