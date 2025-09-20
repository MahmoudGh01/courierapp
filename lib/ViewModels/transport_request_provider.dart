import 'package:courier_app/Models/enums.dart';
import 'package:flutter/foundation.dart';
import '../Models/merchandise_items.dart';
import '../Models/transport_request_model.dart';
import '../Models/merchandise_model.dart';

class TransportRequestProvider extends ChangeNotifier {
  TransportRequestModel _dto = TransportRequestModel(
    idTransportRequest: 0,
    serviceType: "RELOCATION",
    status: "PUBLISHED",
    originAddress: '',
    originState: '',
    originCity: '',
    originPostalCode: '',
    destinationAddress: '',
    destinationState: '',
    destinationCity: '',
    destinationPostalCode: '',
    vehicleType: "SEMI_TRAILER",
    accessType: "LARGE_VEHICLE_ACCESS",
    loadingCapacity: "MEDIUM_DUTY",
    paymentMethod: "CASH_ON_DELIVERY",
    paymentCondition: "PAYMENT_ON_RECEIPT",
    merchandise: MerchandiseModel(
      idMerchandise: 0,
      merchandiseType: 'GENERAL_GOODS',
      description: '',
    ),
    documentPaths: [], // ✅ start empty
  );

  TransportRequestModel get dto => _dto;

// ---------------------------------------------------------
  // STEP 3 — Merchandise: CRUD for each item type
  // ---------------------------------------------------------

  // --- Desk ---
  void addDesk(DeskModel d) {
    final m = _dto.merchandise!;
    m.desks = [...m.desks, d];
    notifyListeners();
  }

  void updateDesk(int index, DeskModel d) {
    final m = _dto.merchandise!;
    m.desks[index] = d;
    notifyListeners();
  }

  void removeDesk(int index) {
    final m = _dto.merchandise!;
    m.desks.removeAt(index);
    notifyListeners();
  }

  // --- Box ---
  void addBox(BoxModel b) {
    final m = _dto.merchandise!;
    m.boxes = [...m.boxes, b];
    notifyListeners();
  }

  void updateBox(int index, BoxModel b) {
    final m = _dto.merchandise!;
    m.boxes[index] = b;
    notifyListeners();
  }

  void removeBox(int index) {
    final m = _dto.merchandise!;
    m.boxes.removeAt(index);
    notifyListeners();
  }

  // --- Cardboard ---
  void addCardboard(CardboardModel c) {
    final m = _dto.merchandise!;
    m.cardboards = [...m.cardboards, c];
    notifyListeners();
  }

  void updateCardboard(int index, CardboardModel c) {
    final m = _dto.merchandise!;
    m.cardboards[index] = c;
    notifyListeners();
  }

  void removeCardboard(int index) {
    final m = _dto.merchandise!;
    m.cardboards.removeAt(index);
    notifyListeners();
  }

  // --- Pallet ---
  void addPallet(PalletModel p) {
    final m = _dto.merchandise!;
    m.pallets = [...m.pallets, p];
    notifyListeners();
  }

  void updatePallet(int index, PalletModel p) {
    final m = _dto.merchandise!;
    m.pallets[index] = p;
    notifyListeners();
  }

  void removePallet(int index) {
    final m = _dto.merchandise!;
    m.pallets.removeAt(index);
    notifyListeners();
  }

  // --- Mattress ---
  void addMattress(MattressModel mtt) {
    final m = _dto.merchandise!;
    m.mattresses = [...m.mattresses, mtt];
    notifyListeners();
  }

  void updateMattress(int index, MattressModel mtt) {
    final m = _dto.merchandise!;
    m.mattresses[index] = mtt;
    notifyListeners();
  }

  void removeMattress(int index) {
    final m = _dto.merchandise!;
    m.mattresses.removeAt(index);
    notifyListeners();
  }

  // --- Sofa ---
  void addSofa(SofaModel s) {
    final m = _dto.merchandise!;
    m.sofas = [...m.sofas, s];
    notifyListeners();
  }

  void updateSofa(int index, SofaModel s) {
    final m = _dto.merchandise!;
    m.sofas[index] = s;
    notifyListeners();
  }

  void removeSofa(int index) {
    final m = _dto.merchandise!;
    m.sofas.removeAt(index);
    notifyListeners();
  }

  // --- Wardrobe ---
  void addWardrobe(WardrobeModel w) {
    final m = _dto.merchandise!;
    m.wardrobes = [...m.wardrobes, w];
    notifyListeners();
  }

  void updateWardrobe(int index, WardrobeModel w) {
    final m = _dto.merchandise!;
    m.wardrobes[index] = w;
    notifyListeners();
  }

  void removeWardrobe(int index) {
    final m = _dto.merchandise!;
    m.wardrobes.removeAt(index);
    notifyListeners();
  }

  // --- Cabinet ---
  void addCabinet(CabinetModel c) {
    final m = _dto.merchandise!;
    m.cabinets = [...m.cabinets, c];
    notifyListeners();
  }

  void updateCabinet(int index, CabinetModel c) {
    final m = _dto.merchandise!;
    m.cabinets[index] = c;
    notifyListeners();
  }

  void removeCabinet(int index) {
    final m = _dto.merchandise!;
    m.cabinets.removeAt(index);
    notifyListeners();
  }

  // --- Furniture (generic) ---
  void addFurniture(FurnitureModel f) {
    final m = _dto.merchandise!;
    m.otherFurniture = [...m.otherFurniture, f];
    notifyListeners();
  }

  void updateFurniture(int index, FurnitureModel f) {
    final m = _dto.merchandise!;
    m.otherFurniture[index] = f;
    notifyListeners();
  }

  void removeFurniture(int index) {
    final m = _dto.merchandise!;
    m.otherFurniture.removeAt(index);
    notifyListeners();
  }

  // ---- Step 1
  void setServiceType(String service) {
    _dto = _dto.copyWith(serviceType: service);
    notifyListeners();
  }

  void setUser(int id) {
    _dto = _dto.copyWith(userId: id);
    notifyListeners();
  }

  void setMerchField({
    // --- Household Counters ---
    int? airConditioners,
    int? deskChairs,
    int? chairs,
    int? washingMachines,
    int? dishWashingMachines,
    int? refrigerators,
    int? televisions,
    int? microwaves,
    int? ovens,
    int? singlePlaceBed,
    int? doublePlaceBed,
    int? masterBedrooms,
    int? dressingTables,

    // --- Freight (FCL) ---
    int? standard20ft,
    int? standard40ft,
    int? highCube40ft,
    String? otherContainers,

    // --- Freight (LCL) ---
    int? palletCount,
    int? boxCount,
    int? objectCount,

    // --- Shared Freight fields ---
    double? totalWeight,
    double? totalVolume,
    String? description,
    bool? isSpecialHandlingRequired,
    bool? isAdditionalProtectionRequired,
    bool? isVehicleWithTailElevatorRequired,
    String? otherRequirements,
    String? merchandiseType,
    String? loadingType,
  }) {
    if (_dto.merchandise != null) {
      _dto.merchandise = _dto.merchandise!.copyWith(
        merchandiseType: merchandiseType ?? _dto.merchandise!.merchandiseType,
        loadingType: loadingType ?? _dto.merchandise!.loadingType,
        // Household
        airConditioners: airConditioners ?? _dto.merchandise!.airConditioners,
        deskChairs: deskChairs ?? _dto.merchandise!.deskChairs,
        chairs: chairs ?? _dto.merchandise!.chairs,
        washingMachines: washingMachines ?? _dto.merchandise!.washingMachines,
        dishWashingMachines: dishWashingMachines ??
            _dto.merchandise!.dishWashingMachines,
        refrigerators: refrigerators ?? _dto.merchandise!.refrigerators,
        televisions: televisions ?? _dto.merchandise!.televisions,
        microwaves: microwaves ?? _dto.merchandise!.microwaves,
        ovens: ovens ?? _dto.merchandise!.ovens,
        singlePlaceBed: singlePlaceBed ?? _dto.merchandise!.singlePlaceBed,
        doublePlaceBed: doublePlaceBed ?? _dto.merchandise!.doublePlaceBed,
        masterBedrooms: masterBedrooms ?? _dto.merchandise!.masterBedrooms,
        dressingTables: dressingTables ?? _dto.merchandise!.dressingTables,

        // Freight (FCL)
        standard20FeetContainersNumber: standard20ft ??
            _dto.merchandise!.standard20FeetContainersNumber,
        standard40FeetContainersNumber: standard40ft ??
            _dto.merchandise!.standard40FeetContainersNumber,
        highCube40FeetContainersNumber: highCube40ft ??
            _dto.merchandise!.highCube40FeetContainersNumber,

        // Freight (LCL)
        pallets: List.generate(
            palletCount ?? _dto.merchandise!.pallets.length, (index) =>
            PalletModel(idPallet: 0,
                length: 0,
                width: 0,
                height: 0,
                weight: 0,
                type: 'STANDARD')),
        boxes: List.generate(
            boxCount ?? _dto.merchandise!.boxes.length, (index) =>
            BoxModel(idBox: 0,
                length: 0,
                width: 0,
                height: 0,
                weight: 0)),

        // Shared Freight
        totalWeight: totalWeight ?? _dto.merchandise!.totalWeight,
        totalVolume: totalVolume ?? _dto.merchandise!.totalVolume,
        description: description ?? _dto.merchandise!.description,
        isSpecialHandlingRequired: isSpecialHandlingRequired ??
            _dto.merchandise!.isSpecialHandlingRequired,
        isAdditionalProtectionRequired: isAdditionalProtectionRequired ??
            _dto.merchandise!.isAdditionalProtectionRequired,
        isVehicleWithTailElevatorRequired: isVehicleWithTailElevatorRequired ??
            _dto.merchandise!.isVehicleWithTailElevatorRequired,
        other: otherRequirements ?? _dto.merchandise!.other,
      );
      notifyListeners();
    }
  }


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
    _dto = _dto.copyWith(
      originAddress: address ?? _dto.originAddress,
      originState: state ?? _dto.originState,
      originCity: city ?? _dto.originCity,
      originPostalCode: postal ?? _dto.originPostalCode,
      originLatitude: lat ?? _dto.originLatitude,
      originLongitude: lng ?? _dto.originLongitude,
      departureFloor: floor ?? _dto.departureFloor,
      isElevatorAvailableForDeparture:
      elevator ?? _dto.isElevatorAvailableForDeparture,
    );
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
    _dto = _dto.copyWith(
      destinationAddress: address ?? _dto.destinationAddress,
      destinationState: state ?? _dto.destinationState,
      destinationCity: city ?? _dto.destinationCity,
      destinationPostalCode: postal ?? _dto.destinationPostalCode,
      destinationLatitude: lat ?? _dto.destinationLatitude,
      destinationLongitude: lng ?? _dto.destinationLongitude,
      arrivalFloor: floor ?? _dto.arrivalFloor,
      isElevatorAvailableForArrival:
      elevator ?? _dto.isElevatorAvailableForArrival,
    );
    notifyListeners();
  }

  // ---- Step 2 (Dates/Times/Flexibility/Dismantling)
  void setScheduling({
    DateTime? pickUpDate,
    DateTime? deliveryDate,
    String? pickUpTime,
    String? deliveryTime,
    int? pickUpFlexDays,
    int? pickUpFlexHours,
    int? deliveryFlexDays,
    int? deliveryFlexHours,
  }) {
    _dto = _dto.copyWith(
      pickUpDate: pickUpDate ?? _dto.pickUpDate,
      deliveryDate: deliveryDate ?? _dto.deliveryDate,
      pickUpTime: pickUpTime ?? _dto.pickUpTime,
      deliveryTime: deliveryTime ?? _dto.deliveryTime,
      pickUpFlexibilityInDays: pickUpFlexDays ?? _dto.pickUpFlexibilityInDays,
      pickUpFlexibilityInHours:
      pickUpFlexHours ?? _dto.pickUpFlexibilityInHours,
      deliveryFlexibilityInDays:
      deliveryFlexDays ?? _dto.deliveryFlexibilityInDays,
      deliveryFlexibilityInHours:
      deliveryFlexHours ?? _dto.deliveryFlexibilityInHours,
    );
    notifyListeners();
  }

  void setDismantling({bool? required, String? type, int? pieces}) {
    _dto = _dto.copyWith(
      isDismantlingRequired: required ?? _dto.isDismantlingRequired,
      dismantlingType: type ?? _dto.dismantlingType,
      numberOfPiecesToDesmantle: pieces ?? _dto.numberOfPiecesToDesmantle,
    );
    notifyListeners();
  }

  // ---- Step 3 (Merchandise)
  void setMerchandise(MerchandiseModel m) {
    _dto = _dto.copyWith(merchandise: m);
    notifyListeners();
  }

  // ---- Step 4 (Vehicle)
  void setVehicle({String? vehicleType,
    String? accessType,
    String? loadingCapacity,
    double? maxW,
    double? maxH}) {
    _dto = _dto.copyWith(
      vehicleType: vehicleType ?? _dto.vehicleType,
      accessType: accessType ?? _dto.accessType,
      loadingCapacity: loadingCapacity ?? _dto.loadingCapacity,
      maxWidth: maxW ?? _dto.maxWidth,
      maxHeight: maxH ?? _dto.maxHeight,
    );
    notifyListeners();
  }

  // ---- Step 5 (Payment)
  void setPayment(
      {String? paymentMethod, String? paymentCondition, String? terms}) {
    _dto = _dto.copyWith(
      paymentMethod: paymentMethod ?? _dto.paymentMethod,
      paymentCondition: paymentCondition ?? _dto.paymentCondition,
      otherTerms: terms ?? _dto.otherTerms,
    );
    notifyListeners();
  }

// ---- Step 6: Additional
  void setAdditionalInstructions(String? txt) {
    _dto = _dto.copyWith(additionalInstructions: txt);
    notifyListeners();
  }

  /// ✅ Add document URL to list
  void addDocumentPath(String path) {
    final updated = List<String>.from(_dto.documentPaths ?? []);
    updated.add(path);
    _dto = _dto.copyWith(documentPaths: updated);
    notifyListeners();
  }

  /// ✅ Remove by index
  void removeDocumentPath(int index) {
    final updated = List<String>.from(_dto.documentPaths ?? []);
    if (index >= 0 && index < updated.length) {
      updated.removeAt(index);
      _dto = _dto.copyWith(documentPaths: updated);
      notifyListeners();
    }
  }

  // ---- Validation
  bool validateStep1() => true;

  bool validateStep2() =>
      _dto.originAddress.isNotEmpty &&
          _dto.originCity.isNotEmpty &&
          _dto.originState.isNotEmpty &&
          _dto.originPostalCode.isNotEmpty &&
          _dto.originLatitude != null &&
          _dto.originLongitude != null &&
          _dto.destinationAddress.isNotEmpty &&
          _dto.destinationCity.isNotEmpty &&
          _dto.destinationState.isNotEmpty &&
          _dto.destinationPostalCode.isNotEmpty &&
          _dto.destinationLatitude != null &&
          _dto.destinationLongitude != null;

  bool validateStep3() => _dto.merchandise != null;

  bool validateStep4() => true;

  bool validateStep5() => true;

  bool validateStep6() => true;

  void reset() {
    _dto = TransportRequestModel(
      idTransportRequest: 0,
      serviceType: "RELOCATION",
      status: "PUBLISHED",
      originAddress: '',
      originState: '',
      originCity: '',
      originPostalCode: '',
      destinationAddress: '',
      destinationState: '',
      destinationCity: '',
      destinationPostalCode: '',
      vehicleType: "SEMI_TRAILER",
      accessType: "LARGE_VEHICLE_ACCESS",
      loadingCapacity: "MEDIUM_DUTY",
      paymentMethod: "CASH_ON_DELIVERY",
      paymentCondition: "PAYMENT_ON_RECEIPT",
      merchandise: MerchandiseModel(
        idMerchandise: 0,
        merchandiseType: '',
        description: '',
      ),
      documentPaths: [],
    );
    notifyListeners();
  }

  bool validateStep3Freight() {
    final m = _dto.merchandise;

    // 🚨 Safety check
    if (m == null) return false;

    // --- Basic required fields ---
    if (m.merchandiseType == null || m.merchandiseType!.isEmpty) return false;
    if (m.loadingType == null || m.loadingType!.isEmpty) return false;

    // --- FCL (Full Container Load) ---
    if (m.loadingType == LoadingType.FULL_CONTAINER.name) {
      final totalContainers = (m.standard20FeetContainersNumber ?? 0) +
          (m.standard40FeetContainersNumber ?? 0) +
          (m.highCube40FeetContainersNumber ?? 0);
      if (totalContainers == 0) return false; // must have at least 1 container
      if (m.totalWeight == null || m.totalWeight! <= 0) return false;
      // totalVolume optional
    }

    // --- LCL (Partial Load) ---
    if (m.loadingType == LoadingType.PARTIAL.name) {
      final totalItems =
          (m.pallets.length ?? 0) + (m.boxes.length ?? 0);

      if (totalItems == 0) return false; // must have at least 1 item
      if (m.totalWeight == null || m.totalWeight! <= 0) return false;
      // totalVolume optional
    }

    // --- If all checks passed ---
    return true;
  }

}