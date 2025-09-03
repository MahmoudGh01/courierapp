// merchandise_item.dart
class MerchandiseItem {
  String category;   // e.g. 'Cardboards', 'Desks', 'Cabinets'
  double weightKg;
  double lengthCm;
  double widthCm;
  double heightCm;
  bool fragile;

  MerchandiseItem({
    required this.category,
    this.weightKg = 0,
    this.lengthCm = 0,
    this.widthCm = 0,
    this.heightCm = 0,
    this.fragile = false,
  });

  double get volumeM3 => (lengthCm / 100) * (widthCm / 100) * (heightCm / 100);

  Map<String, dynamic> toJson() => {
    'category': category,
    'weightKg': weightKg,
    'lengthCm': lengthCm,
    'widthCm': widthCm,
    'heightCm': heightCm,
    'fragile': fragile,
  };
}
