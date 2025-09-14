// lib/models/merchandise_items.dart

// ---------------- Desk ----------------
class DeskModel {
  final int? idDesk;
  final double weight;
  final double length;
  final double width;
  final double height;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DeskModel({
    this.idDesk,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    this.createdAt,
    this.updatedAt,
  });

  DeskModel copyWith({
    int? idDesk,
    double? weight,
    double? length,
    double? width,
    double? height,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeskModel(
      idDesk: idDesk ?? this.idDesk,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory DeskModel.fromJson(Map<String, dynamic> j) => DeskModel(
    idDesk: j['idDesk'],
    weight: (j['weight'] as num).toDouble(),
    length: (j['length'] as num).toDouble(),
    width: (j['width'] as num).toDouble(),
    height: (j['height'] as num).toDouble(),
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idDesk": idDesk,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    
    
  };
}

// ---------------- Cabinet ----------------
class CabinetModel {
  final int? idCabinet;
  final double weight, length, width, height;
  final DateTime? createdAt, updatedAt;

  CabinetModel({
    this.idCabinet,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    this.createdAt,
    this.updatedAt,
  });

  CabinetModel copyWith({
    int? idCabinet,
    double? weight,
    double? length,
    double? width,
    double? height,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CabinetModel(
      idCabinet: idCabinet ?? this.idCabinet,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CabinetModel.fromJson(Map<String, dynamic> j) => CabinetModel(
    idCabinet: j['idCabinet'],
    weight: (j['weight'] as num).toDouble(),
    length: (j['length'] as num).toDouble(),
    width: (j['width'] as num).toDouble(),
    height: (j['height'] as num).toDouble(),
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idCabinet": idCabinet,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    
    
  };
}

// ---------------- Wardrobe ----------------
class WardrobeModel {
  final int? idWardrobe;
  final double weight, length, width, height;
  final DateTime? createdAt, updatedAt;

  WardrobeModel({
    this.idWardrobe,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    this.createdAt,
    this.updatedAt,
  });

  WardrobeModel copyWith({
    int? idWardrobe,
    double? weight,
    double? length,
    double? width,
    double? height,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WardrobeModel(
      idWardrobe: idWardrobe ?? this.idWardrobe,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory WardrobeModel.fromJson(Map<String, dynamic> j) => WardrobeModel(
    idWardrobe: j['idWardrobe'],
    weight: (j['weight'] as num).toDouble(),
    length: (j['length'] as num).toDouble(),
    width: (j['width'] as num).toDouble(),
    height: (j['height'] as num).toDouble(),
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idWardrobe": idWardrobe,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    
    
  };
}

// ---------------- Table ----------------
class TableModel {
  final int? idTable;
  final double weight, length, width, height;
  final DateTime? createdAt, updatedAt;

  TableModel({
    this.idTable,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    this.createdAt,
    this.updatedAt,
  });

  TableModel copyWith({
    int? idTable,
    double? weight,
    double? length,
    double? width,
    double? height,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TableModel(
      idTable: idTable ?? this.idTable,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TableModel.fromJson(Map<String, dynamic> j) => TableModel(
    idTable: j['idTable'],
    weight: (j['weight'] as num).toDouble(),
    length: (j['length'] as num).toDouble(),
    width: (j['width'] as num).toDouble(),
    height: (j['height'] as num).toDouble(),
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idTable": idTable,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    
    
  };
}

// ---------------- Sofa ----------------
class SofaModel {
  final int? idSofa;
  final double weight, length, width, height;
  final DateTime? createdAt, updatedAt;

  SofaModel({
    this.idSofa,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    this.createdAt,
    this.updatedAt,
  });

  SofaModel copyWith({
    int? idSofa,
    double? weight,
    double? length,
    double? width,
    double? height,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SofaModel(
      idSofa: idSofa ?? this.idSofa,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory SofaModel.fromJson(Map<String, dynamic> j) => SofaModel(
    idSofa: j['idSofa'],
    weight: (j['weight'] as num).toDouble(),
    length: (j['length'] as num).toDouble(),
    width: (j['width'] as num).toDouble(),
    height: (j['height'] as num).toDouble(),
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idSofa": idSofa,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    
    
  };
}

// ---------------- Mattress ----------------
class MattressModel {
  final int? idMattress;
  final double length, width, weight;
  final DateTime? createdAt, updatedAt;

  MattressModel({
    this.idMattress,
    required this.length,
    required this.width,
    required this.weight,
    this.createdAt,
    this.updatedAt,
  });

  MattressModel copyWith({
    int? idMattress,
    double? length,
    double? width,
    double? weight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MattressModel(
      idMattress: idMattress ?? this.idMattress,
      length: length ?? this.length,
      width: width ?? this.width,
      weight: weight ?? this.weight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MattressModel.fromJson(Map<String, dynamic> j) => MattressModel(
    idMattress: j['idMattress'],
    length: (j['length'] as num).toDouble(),
    width: (j['width'] as num).toDouble(),
    weight: (j['weight'] as num).toDouble(),
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idMattress": idMattress,
    "length": length,
    "width": width,
    "weight": weight,
    
    
  };
}
// ---------------- Cardboard ----------------
class CardboardModel {
  final int? idCardboard;
  final double weight, length, width, height;
  final bool isFragile;
  final DateTime? createdAt, updatedAt;

  CardboardModel({
    this.idCardboard,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.isFragile,
    this.createdAt,
    this.updatedAt,
  });

  CardboardModel copyWith({
    int? idCardboard,
    double? weight,
    double? length,
    double? width,
    double? height,
    bool? isFragile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CardboardModel(
      idCardboard: idCardboard ?? this.idCardboard,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      isFragile: isFragile ?? this.isFragile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CardboardModel.fromJson(Map<String, dynamic> j) => CardboardModel(
    idCardboard: j['idCardboard'],
    weight: (j['weight'] as num).toDouble(),
    length: (j['length'] as num).toDouble(),
    width: (j['width'] as num).toDouble(),
    height: (j['height'] as num).toDouble(),
    isFragile: j['isFragile'] ?? false,
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idCardboard": idCardboard,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    "isFragile": isFragile,
    
    
  };
}

// ---------------- Box ----------------
class BoxModel {
  final int? idBox;
  final double weight, length, width, height;
  final DateTime? createdAt, updatedAt;

  BoxModel({
    this.idBox,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    this.createdAt,
    this.updatedAt,
  });

  BoxModel copyWith({
    int? idBox,
    double? weight,
    double? length,
    double? width,
    double? height,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BoxModel(
      idBox: idBox ?? this.idBox,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory BoxModel.fromJson(Map<String, dynamic> j) => BoxModel(
    idBox: j['idBox'],
    weight: (j['weight'] as num).toDouble(),
    length: (j['length'] as num).toDouble(),
    width: (j['width'] as num).toDouble(),
    height: (j['height'] as num).toDouble(),
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idBox": idBox,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    
    
  };
}

// ---------------- Pallet ----------------
class PalletModel {
  final int? idPallet;
  final double weight, length, width, height;
  final String type;
  final DateTime? createdAt, updatedAt;

  PalletModel({
    this.idPallet,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  PalletModel copyWith({
    int? idPallet,
    double? weight,
    double? length,
    double? width,
    double? height,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PalletModel(
      idPallet: idPallet ?? this.idPallet,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory PalletModel.fromJson(Map<String, dynamic> j) => PalletModel(
    idPallet: j['idPallet'],
    weight: (j['weight'] as num).toDouble(),
    length: (j['length'] as num).toDouble(),
    width: (j['width'] as num).toDouble(),
    height: (j['height'] as num).toDouble(),
    type: j['type'],
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idPallet": idPallet,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    "type": type,
    
    
  };
}

// ---------------- Furniture ----------------
class FurnitureModel {
  final int? idFurniture;
  final String? description;
  final double weight, length, width, height;
  final bool isFragile;
  final DateTime? createdAt, updatedAt;

  FurnitureModel({
    this.idFurniture,
    this.description,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.isFragile,
    this.createdAt,
    this.updatedAt,
  });

  FurnitureModel copyWith({
    int? idFurniture,
    String? description,
    double? weight,
    double? length,
    double? width,
    double? height,
    bool? isFragile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FurnitureModel(
      idFurniture: idFurniture ?? this.idFurniture,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      isFragile: isFragile ?? this.isFragile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory FurnitureModel.fromJson(Map<String, dynamic> j) => FurnitureModel(
    idFurniture: j['idFurniture'],
    description: j['description'],
    weight: (j['weight'] as num).toDouble(),
    length: (j['length'] as num).toDouble(),
    width: (j['width'] as num).toDouble(),
    height: (j['height'] as num).toDouble(),
    isFragile: j['isFragile'] ?? false,
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idFurniture": idFurniture,
    "description": description,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    "isFragile": isFragile,
    
    
  };
}

// ---------------- Objet ----------------
class ObjetModel {
  final int? idObjet;
  final String description;
  final double weight;
  final double? length, width, height, volume;
  final bool? isFragile;
  final DateTime? createdAt, updatedAt;

  ObjetModel({
    this.idObjet,
    required this.description,
    required this.weight,
    this.length,
    this.width,
    this.height,
    this.volume,
    this.isFragile,
    this.createdAt,
    this.updatedAt,
  });

  ObjetModel copyWith({
    int? idObjet,
    String? description,
    double? weight,
    double? length,
    double? width,
    double? height,
    double? volume,
    bool? isFragile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ObjetModel(
      idObjet: idObjet ?? this.idObjet,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      volume: volume ?? this.volume,
      isFragile: isFragile ?? this.isFragile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ObjetModel.fromJson(Map<String, dynamic> j) => ObjetModel(
    idObjet: j['idObjet'],
    description: j['description'],
    weight: (j['weight'] as num).toDouble(),
    length: (j['length'] as num?)?.toDouble(),
    width: (j['width'] as num?)?.toDouble(),
    height: (j['height'] as num?)?.toDouble(),
    volume: (j['volume'] as num?)?.toDouble(),
    isFragile: j['isFragile'],
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "idObjet": idObjet,
    "description": description,
    "weight": weight,
    "length": length,
    "width": width,
    "height": height,
    "volume": volume,
    "isFragile": isFragile,
    
    
  };
}
