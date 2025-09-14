// lib/models/transport_request_model.dart
import 'merchandise_model.dart';

class TransportRequestModel {
  int idTransportRequest;

  String serviceType;
  String status;

  String originAddress;
  String originState;
  String originCity;
  String originPostalCode;
  double? originLatitude;
  double? originLongitude;

  String destinationAddress;
  String destinationState;
  String destinationCity;
  String destinationPostalCode;
  double? destinationLatitude;
  double? destinationLongitude;

  DateTime? pickUpDate;
  DateTime? deliveryDate;
  String? pickUpTime;
  String? deliveryTime;
  int? pickUpFlexibilityInDays;
  int? pickUpFlexibilityInHours;
  int? deliveryFlexibilityInDays;
  int? deliveryFlexibilityInHours;

  bool? isDismantlingRequired;
  String? dismantlingType;
  int? numberOfPiecesToDesmantle;
  int? departureFloor;
  int? arrivalFloor;
  bool? isElevatorAvailableForDeparture;
  bool? isElevatorAvailableForArrival;

  String vehicleType;
  String accessType;
  String loadingCapacity;
  double? maxWidth;
  double? maxHeight;

  String paymentMethod;
  String paymentCondition;
  String? otherTerms;

  String? additionalInstructions;

  int? userId;

  MerchandiseModel? merchandise;
  List? documentPaths;
  DateTime? createdAt;
  DateTime? updatedAt;

  TransportRequestModel({
    required this.idTransportRequest,
    required this.serviceType,
    required this.status,
    required this.originAddress,
    required this.originState,
    required this.originCity,
    required this.originPostalCode,
    this.originLatitude,
    this.originLongitude,
    required this.destinationAddress,
    required this.destinationState,
    required this.destinationCity,
    required this.destinationPostalCode,
    this.destinationLatitude,
    this.destinationLongitude,
    this.pickUpDate,
    this.deliveryDate,
    this.pickUpTime,
    this.deliveryTime,
    this.pickUpFlexibilityInDays,
    this.pickUpFlexibilityInHours,
    this.deliveryFlexibilityInDays,
    this.deliveryFlexibilityInHours,
    this.isDismantlingRequired,
    this.dismantlingType,
    this.numberOfPiecesToDesmantle,
    this.departureFloor,
    this.arrivalFloor,
    this.isElevatorAvailableForDeparture,
    this.isElevatorAvailableForArrival,
    required this.vehicleType,
    required this.accessType,
    required this.loadingCapacity,
    this.maxWidth,
    this.maxHeight,
    required this.paymentMethod,
    required this.paymentCondition,
    this.otherTerms,
    this.additionalInstructions,
    this.userId,
    this.merchandise,
    this.createdAt,
    this.updatedAt,
    this.documentPaths,
  });

  factory TransportRequestModel.fromJson(Map<String, dynamic> j) {
    return TransportRequestModel(
      idTransportRequest: j['idTransportRequest'] ?? 0,
      serviceType: j['serviceType'] ?? '',
      status: j['status'] ?? '',
      originAddress: j['originAddress'] ?? '',
      originState: j['originState'] ?? '',
      originCity: j['originCity'] ?? '',
      originPostalCode: j['originPostalCode'] ?? '',
      originLatitude: (j['originLatitude'] as num?)?.toDouble(),
      originLongitude: (j['originLongitude'] as num?)?.toDouble(),
      destinationAddress: j['destinationAddress'] ?? '',
      destinationState: j['destinationState'] ?? '',
      destinationCity: j['destinationCity'] ?? '',
      destinationPostalCode: j['destinationPostalCode'] ?? '',
      destinationLatitude: (j['destinationLatitude'] as num?)?.toDouble(),
      destinationLongitude: (j['destinationLongitude'] as num?)?.toDouble(),
      pickUpDate:
          j['pickUpDate'] != null ? DateTime.tryParse(j['pickUpDate']) : null,
      deliveryDate: j['deliveryDate'] != null
          ? DateTime.tryParse(j['deliveryDate'])
          : null,
      pickUpTime: j['pickUpTime'],
      deliveryTime: j['deliveryTime'],
      pickUpFlexibilityInDays: j['pickUpFlexibilityInDays'],
      pickUpFlexibilityInHours: j['pickUpFlexibilityInHours'],
      deliveryFlexibilityInDays: j['deliveryFlexibilityInDays'],
      deliveryFlexibilityInHours: j['deliveryFlexibilityInHours'],
      isDismantlingRequired: j['isDismantlingRequired'],
      dismantlingType: j['dismantlingType'],
      numberOfPiecesToDesmantle: j['numberOfPiecesToDesmantle'],
      departureFloor: j['departureFloor'],
      arrivalFloor: j['arrivalFloor'],
      isElevatorAvailableForDeparture: j['isElevatorAvailableForDeparture'],
      isElevatorAvailableForArrival: j['isElevatorAvailableForArrival'],
      vehicleType: j['vehicleType'] ?? '',
      accessType: j['accessType'] ?? '',
      loadingCapacity: j['loadingCapacity'] ?? '',
      maxWidth: (j['maxWidth'] as num?)?.toDouble(),
      maxHeight: (j['maxHeight'] as num?)?.toDouble(),
      paymentMethod: j['paymentMethod'] ?? '',
      paymentCondition: j['paymentCondition'] ?? '',
      otherTerms: j['otherTerms'],
      additionalInstructions: j['additionalInstructions'],
      userId: j['user'] != null ? j['user']['idUser'] : null,
      merchandise: j['merchandise'] != null
          ? MerchandiseModel.fromJson(j['merchandise'])
          : null,
      createdAt:
          j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
      updatedAt:
          j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
      documentPaths: [],
    );
  }
  Map<String, dynamic> toJson() {
    //print(userId);
    return {
      'idTransportRequest': idTransportRequest,
      'serviceType': serviceType,
      'status': status,
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
      'dismantlingType': dismantlingType,
      'numberOfPiecesToDesmantle': numberOfPiecesToDesmantle,
      'departureFloor': departureFloor,
      'arrivalFloor': arrivalFloor,
      'isElevatorAvailableForDeparture': isElevatorAvailableForDeparture,
      'isElevatorAvailableForArrival': isElevatorAvailableForArrival,
      'vehicleType': vehicleType,
      'accessType': accessType,
      'loadingCapacity': loadingCapacity,
      'maxWidth': maxWidth,
      'maxHeight': maxHeight,
      'paymentMethod': paymentMethod,
      'paymentCondition': paymentCondition,
      'otherTerms': otherTerms,
      'additionalInstructions': additionalInstructions,
      'user':  {'idUser': userId} ,
      'merchandise': merchandise?.toJson(),

    };
  }

  TransportRequestModel copyWith({
    int? idTransportRequest,
    String? serviceType,
    String? status,
    String? originAddress,
    String? originState,
    String? originCity,
    String? originPostalCode,
    double? originLatitude,
    double? originLongitude,
    String? destinationAddress,
    String? destinationState,
    String? destinationCity,
    String? destinationPostalCode,
    double? destinationLatitude,
    double? destinationLongitude,
    DateTime? pickUpDate,
    DateTime? deliveryDate,
    String? pickUpTime,
    String? deliveryTime,
    int? pickUpFlexibilityInDays,
    int? pickUpFlexibilityInHours,
    int? deliveryFlexibilityInDays,
    int? deliveryFlexibilityInHours,
    bool? isDismantlingRequired,
    String? dismantlingType,
    int? numberOfPiecesToDesmantle,
    int? departureFloor,
    int? arrivalFloor,
    bool? isElevatorAvailableForDeparture,
    bool? isElevatorAvailableForArrival,
    String? vehicleType,
    String? accessType,
    String? loadingCapacity,
    double? maxWidth,
    double? maxHeight,
    String? paymentMethod,
    String? paymentCondition,
    String? otherTerms,
    String? additionalInstructions,
    int? userId,
    MerchandiseModel? merchandise,
    DateTime? createdAt,
    DateTime? updatedAt,
    List? documentPaths,
  }) {
    return TransportRequestModel(
      idTransportRequest: idTransportRequest ?? this.idTransportRequest,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      originAddress: originAddress ?? this.originAddress,
      originState: originState ?? this.originState,
      originCity: originCity ?? this.originCity,
      originPostalCode: originPostalCode ?? this.originPostalCode,
      originLatitude: originLatitude ?? this.originLatitude,
      originLongitude: originLongitude ?? this.originLongitude,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      destinationState: destinationState ?? this.destinationState,
      destinationCity: destinationCity ?? this.destinationCity,
      destinationPostalCode:
          destinationPostalCode ?? this.destinationPostalCode,
      destinationLatitude: destinationLatitude ?? this.destinationLatitude,
      destinationLongitude: destinationLongitude ?? this.destinationLongitude,
      pickUpDate: pickUpDate ?? this.pickUpDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      pickUpTime: pickUpTime ?? this.pickUpTime,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      pickUpFlexibilityInDays:
          pickUpFlexibilityInDays ?? this.pickUpFlexibilityInDays,
      pickUpFlexibilityInHours:
          pickUpFlexibilityInHours ?? this.pickUpFlexibilityInHours,
      deliveryFlexibilityInDays:
          deliveryFlexibilityInDays ?? this.deliveryFlexibilityInDays,
      deliveryFlexibilityInHours:
          deliveryFlexibilityInHours ?? this.deliveryFlexibilityInHours,
      isDismantlingRequired:
          isDismantlingRequired ?? this.isDismantlingRequired,
      dismantlingType: dismantlingType ?? this.dismantlingType,
      numberOfPiecesToDesmantle:
          numberOfPiecesToDesmantle ?? this.numberOfPiecesToDesmantle,
      departureFloor: departureFloor ?? this.departureFloor,
      arrivalFloor: arrivalFloor ?? this.arrivalFloor,
      isElevatorAvailableForDeparture: isElevatorAvailableForDeparture ??
          this.isElevatorAvailableForDeparture,
      isElevatorAvailableForArrival:
          isElevatorAvailableForArrival ?? this.isElevatorAvailableForArrival,
      vehicleType: vehicleType ?? this.vehicleType,
      accessType: accessType ?? this.accessType,
      loadingCapacity: loadingCapacity ?? this.loadingCapacity,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentCondition: paymentCondition ?? this.paymentCondition,
      otherTerms: otherTerms ?? this.otherTerms,
      additionalInstructions:
          additionalInstructions ?? this.additionalInstructions,
      userId: userId ?? this.userId,
      merchandise: merchandise ?? this.merchandise,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      documentPaths: documentPaths ?? this.documentPaths,
    );
  }
}
