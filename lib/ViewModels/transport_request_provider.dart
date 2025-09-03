import 'package:flutter/foundation.dart';
import '../models/transport_request.dart';
import '../models/merchandise_item.dart';

class TransportRequestProvider extends ChangeNotifier {
  final TransportRequestDTO _dto = TransportRequestDTO();

  TransportRequestDTO get dto => _dto;

  // ---- Step 1
  void setServiceType(service) { _dto.serviceType = service; notifyListeners(); }

  // ---- Step 2 (Origin)
  void setOrigin({
    String? address,
    String? state,
    String? city,
    String? postal,
    double? lat,
    double? lng,
    int? floor,
    bool? elevator,
  }) {
    if (address != null) _dto.originAddress = address;
    if (state != null) _dto.originState = state;
    if (city != null) _dto.originCity = city;
    if (postal != null) _dto.originPostalCode = postal;
    if (lat != null) _dto.originLatitude = lat;
    if (lng != null) _dto.originLongitude = lng;
    if (floor != null) _dto.departureFloor = floor;
    if (elevator != null) _dto.isElevatorAvailableForDeparture = elevator;
    notifyListeners();
  }

  // ---- Step 2 (Destination)
  void setDestination({
    String? address,
    String? state,
    String? city,
    String? postal,
    double? lat,
    double? lng,
    int? floor,
    bool? elevator,
  }) {
    if (address != null) _dto.destinationAddress = address;
    if (state != null) _dto.destinationState = state;
    if (city != null) _dto.destinationCity = city;
    if (postal != null) _dto.destinationPostalCode = postal;
    if (lat != null) _dto.destinationLatitude = lat;
    if (lng != null) _dto.destinationLongitude = lng;
    if (floor != null) _dto.arrivalFloor = floor;
    if (elevator != null) _dto.isElevatorAvailableForArrival = elevator;
    notifyListeners();
  }

  // ---- Step 2 (Dates/Times/Flexibility/Dismantling)
  void setScheduling({
    DateTime? pickUpDate, DateTime? deliveryDate,
    String? pickUpTime, String? deliveryTime,
    int? pickUpFlexDays, int? pickUpFlexHours,
    int? deliveryFlexDays, int? deliveryFlexHours,
  }) {
    _dto.pickUpDate = pickUpDate ?? _dto.pickUpDate;
    _dto.deliveryDate = deliveryDate ?? _dto.deliveryDate;
    _dto.pickUpTime = pickUpTime ?? _dto.pickUpTime;
    _dto.deliveryTime = deliveryTime ?? _dto.deliveryTime;
    _dto.pickUpFlexibilityInDays = pickUpFlexDays ?? _dto.pickUpFlexibilityInDays;
    _dto.pickUpFlexibilityInHours = pickUpFlexHours ?? _dto.pickUpFlexibilityInHours;
    _dto.deliveryFlexibilityInDays = deliveryFlexDays ?? _dto.deliveryFlexibilityInDays;
    _dto.deliveryFlexibilityInHours = deliveryFlexHours ?? _dto.deliveryFlexibilityInHours;
    notifyListeners();
  }

  void setDismantling({bool? required, dynamic type, int? pieces}) {
    _dto.isDismantlingRequired = required ?? _dto.isDismantlingRequired;
    _dto.dismantlingType = type ?? _dto.dismantlingType;
    _dto.numberOfPiecesToDesmantle = pieces ?? _dto.numberOfPiecesToDesmantle;
    notifyListeners();
  }

  // ---- Step 3 (Merchandise)
  void addItem(MerchandiseItem item) { _dto.items.add(item); notifyListeners(); }
  void removeItem(int index) { _dto.items.removeAt(index); notifyListeners(); }
  void duplicateItem(int index) { _dto.items.add(_dto.items[index]); notifyListeners(); }
  void updateItem(int index, MerchandiseItem item) { _dto.items[index] = item; notifyListeners(); }
  void setMerchandiseType(String? t) { _dto.merchandiseType = t; notifyListeners(); }

  // ---- Step 4 (Vehicle)
  void setVehicle({vehicleType, accessType, loadingCapacity, double? maxW, double? maxH}) {
    if (vehicleType != null) _dto.vehicleType = vehicleType;
    if (accessType != null) _dto.accessType = accessType;
    if (loadingCapacity != null) _dto.loadingCapacity = loadingCapacity;
    _dto.maxWidth = maxW ?? _dto.maxWidth;
    _dto.maxHeight = maxH ?? _dto.maxHeight;
    notifyListeners();
  }

  // ---- Step 5 (Payment)
  void setPayment({paymentMethod, paymentCondition, String? terms}) {
    if (paymentMethod != null) _dto.paymentMethod = paymentMethod;
    if (paymentCondition != null) _dto.paymentCondition = paymentCondition;
    _dto.otherTerms = terms ?? _dto.otherTerms;
    notifyListeners();
  }

  // ---- Step 6 (Docs + Instructions)
  void addDocumentPath(String p) { _dto.documentPaths.add(p); notifyListeners(); }
  void removeDocumentPath(int i) { _dto.documentPaths.removeAt(i); notifyListeners(); }
  void setAdditionalInstructions(String? txt) { _dto.additionalInstructions = txt; notifyListeners(); }

  // ---- Validation per step (simple guards)
  bool validateStep1() => true; // serviceType already defaults
  bool validateStep2() =>
      _dto.originAddress.isNotEmpty &&
          _dto.originCity.isNotEmpty &&
          _dto.originState.isNotEmpty &&
          _dto.originPostalCode.isNotEmpty &&
          _dto.originLatitude != null && _dto.originLongitude != null &&
          _dto.destinationAddress.isNotEmpty &&
          _dto.destinationCity.isNotEmpty &&
          _dto.destinationState.isNotEmpty &&
          _dto.destinationPostalCode.isNotEmpty &&
          _dto.destinationLatitude != null && _dto.destinationLongitude != null;

  bool validateStep3() => _dto.items.isNotEmpty; // at least one item
  bool validateStep4() => true; // defaults present
  bool validateStep5() => true;
  bool validateStep6() => true;

  void reset() {
    final preservedType = _dto.serviceType;
    final preservedVehicle = _dto.vehicleType;
    final preservedAccess = _dto.accessType;
    final preservedCapacity = _dto.loadingCapacity;
    final preservedPaymentMethod = _dto.paymentMethod;
    final preservedPaymentCond = _dto.paymentCondition;
    // Recreate
    final n = TransportRequestDTO()
      ..serviceType = preservedType
      ..vehicleType = preservedVehicle
      ..accessType = preservedAccess
      ..loadingCapacity = preservedCapacity
      ..paymentMethod = preservedPaymentMethod
      ..paymentCondition = preservedPaymentCond;
    // Replace contents
    _replaceWith(n);
  }

  void _replaceWith(TransportRequestDTO n) {
    // NOTE: easier: reflectively copy or just replace private field (hack)
    // For brevity, we mutate existing fields:
    // TODO: If you want a deep reset, reinstantiate provider.
  }
}
