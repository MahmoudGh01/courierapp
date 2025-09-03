// lib/Service/address_parts.dart
class AddressParts {
  final String formattedAddress;
  final String? state;
  final String? city;
  final String? postalCode;
  final double? lat;
  final double? lng;

  AddressParts({
    required this.formattedAddress,
    this.state,
    this.city,
    this.postalCode,
    this.lat,
    this.lng,
  });
}
