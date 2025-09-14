import 'merchandise_items.dart';

class MerchandiseModel {
  int idMerchandise;
  String merchandiseType;
  String description;
  String? loadingType;
  double? totalWeight;
  double? totalVolume;

  // Containers
  int? standard20FeetContainersNumber;
  int? standard40FeetContainersNumber;
  int? highCube40FeetContainersNumber;

  // Flags
  bool? isSpecialHandlingRequired;
  bool? isAdditionalProtectionRequired;
  bool? isVehicleWithTailElevatorRequired;
  String? other;

  // Nested items
  List<DeskModel> desks;
  List<CabinetModel> cabinets;
  List<CardboardModel> cardboards;
  List<BoxModel> boxes;
  List<PalletModel> pallets;
  List<WardrobeModel> wardrobes;
  List<SofaModel> sofas;
  List<MattressModel> mattresses;
  List<FurnitureModel> otherFurniture;

  // Furniture counts
  int? airConditioners;
  int? deskChairs;
  int? chairs;
  int? washingMachines;
  int? dishWashingMachines;
  int? refrigerators;
  int? televisions;
  int? microwaves;
  int? ovens;
  int? singlePlaceBed;
  int? doublePlaceBed;
  int? masterBedrooms;
  int? dressingTables;

  DateTime? createdAt;
  DateTime? updatedAt;

  MerchandiseModel({
    required this.idMerchandise,
    required this.merchandiseType,
    required this.description,
    this.loadingType,
    this.totalWeight,
    this.totalVolume,
    this.standard20FeetContainersNumber,
    this.standard40FeetContainersNumber,
    this.highCube40FeetContainersNumber,
    this.isSpecialHandlingRequired,
    this.isAdditionalProtectionRequired,
    this.isVehicleWithTailElevatorRequired,
    this.other,
    this.desks = const [],
    this.cabinets = const [],
    this.cardboards = const [],
    this.boxes = const [],
    this.pallets = const [],
    this.wardrobes = const [],
    this.sofas = const [],
    this.mattresses = const [],
    this.otherFurniture = const [],
    this.airConditioners,
    this.deskChairs,
    this.chairs,
    this.washingMachines,
    this.dishWashingMachines,
    this.refrigerators,
    this.televisions,
    this.microwaves,
    this.ovens,
    this.singlePlaceBed,
    this.doublePlaceBed,
    this.masterBedrooms,
    this.dressingTables,
    this.createdAt,
    this.updatedAt,
  });

  factory MerchandiseModel.fromJson(Map<String, dynamic> j) {
    return MerchandiseModel(
      idMerchandise: j['idMerchandise'] ?? 0,
      merchandiseType: j['merchandiseType'] ?? '',
      description: j['description'] ?? '',
      loadingType: j['loadingType'],
      totalWeight: (j['totalWeight'] as num?)?.toDouble(),
      totalVolume: (j['totalVolume'] as num?)?.toDouble(),
      standard20FeetContainersNumber: j['standard20FeetContainersNumber'],
      standard40FeetContainersNumber: j['standard40FeetContainersNumber'],
      highCube40FeetContainersNumber: j['highCube40FeetContainersNumber'],
      isSpecialHandlingRequired: j['isSpecialHandlingRequired'],
      isAdditionalProtectionRequired: j['isAdditionalProtectionRequired'],
      isVehicleWithTailElevatorRequired: j['isVehicleWithTailElevatorRequired'],
      other: j['other'],
      desks: (j['desks'] as List<dynamic>? ?? [])
          .map((e) => DeskModel.fromJson(e))
          .toList(),
      cabinets: (j['cabinets'] as List<dynamic>? ?? [])
          .map((e) => CabinetModel.fromJson(e))
          .toList(),
      cardboards: (j['cardboards'] as List<dynamic>? ?? [])
          .map((e) => CardboardModel.fromJson(e))
          .toList(),
      boxes: (j['boxes'] as List<dynamic>? ?? [])
          .map((e) => BoxModel.fromJson(e))
          .toList(),
      pallets: (j['pallets'] as List<dynamic>? ?? [])
          .map((e) => PalletModel.fromJson(e))
          .toList(),
      wardrobes: (j['wardrobes'] as List<dynamic>? ?? [])
          .map((e) => WardrobeModel.fromJson(e))
          .toList(),
      sofas: (j['sofas'] as List<dynamic>? ?? [])
          .map((e) => SofaModel.fromJson(e))
          .toList(),
      mattresses: (j['mattresses'] as List<dynamic>? ?? [])
          .map((e) => MattressModel.fromJson(e))
          .toList(),
      otherFurniture: (j['otherFurniture'] as List<dynamic>? ?? [])
          .map((e) => FurnitureModel.fromJson(e))
          .toList(),
      airConditioners: j['airConditioners'],
      deskChairs: j['deskChairs'],
      chairs: j['chairs'],
      washingMachines: j['washingMachines'],
      dishWashingMachines: j['dishWashingMachines'],
      refrigerators: j['refrigerators'],
      televisions: j['televisions'],
      microwaves: j['microwaves'],
      ovens: j['ovens'],
      singlePlaceBed: j['singlePlaceBed'],
      doublePlaceBed: j['doublePlaceBed'],
      masterBedrooms: j['masterBedrooms'],
      dressingTables: j['dressingTables'],
      createdAt:
          j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
      updatedAt:
          j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "idMerchandise": idMerchandise,
        "merchandiseType": merchandiseType,
        "description": description,
        "loadingType": loadingType,
        "totalWeight": totalWeight,
        "totalVolume": totalVolume,
        "standard20FeetContainersNumber": standard20FeetContainersNumber,
        "standard40FeetContainersNumber": standard40FeetContainersNumber,
        "highCube40FeetContainersNumber": highCube40FeetContainersNumber,
        "isSpecialHandlingRequired": isSpecialHandlingRequired,
        "isAdditionalProtectionRequired": isAdditionalProtectionRequired,
        "isVehicleWithTailElevatorRequired": isVehicleWithTailElevatorRequired,
        "other": other,
        "desks": desks.map((e) => e.toJson()).toList(),
        "cabinets": cabinets.map((e) => e.toJson()).toList(),
        "cardboards": cardboards.map((e) => e.toJson()).toList(),
        "boxes": boxes.map((e) => e.toJson()).toList(),
        "pallets": pallets.map((e) => e.toJson()).toList(),
        "wardrobes": wardrobes.map((e) => e.toJson()).toList(),
        "sofas": sofas.map((e) => e.toJson()).toList(),
        "mattresses": mattresses.map((e) => e.toJson()).toList(),
        "otherFurniture": otherFurniture.map((e) => e.toJson()).toList(),
        "airConditioners": airConditioners,
        "deskChairs": deskChairs,
        "chairs": chairs,
        "washingMachines": washingMachines,
        "dishWashingMachines": dishWashingMachines,
        "refrigerators": refrigerators,
        "televisions": televisions,
        "microwaves": microwaves,
        "ovens": ovens,
        "singlePlaceBed": singlePlaceBed,
        "doublePlaceBed": doublePlaceBed,
        "masterBedrooms": masterBedrooms,
        "dressingTables": dressingTables,

      };
}
