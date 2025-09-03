// lib/Service/google_places_service.dart
import 'package:google_place/google_place.dart';
import 'package:geocoding/geocoding.dart' as geo;

import 'address_parts.dart';

class GooglePlacesService {
  final GooglePlace _gp;

  GooglePlacesService(String apiKey) : _gp = GooglePlace(apiKey);

  /// Autocomplete wrapper (UI still consumes AutocompletePrediction for list)
  Future<List<AutocompletePrediction>> autocomplete(String input) async {
    final res = await _gp.autocomplete.get(input, language: 'en');
    return res?.predictions ?? <AutocompletePrediction>[];
  }

  /// Fetch details by placeId and return unified AddressParts
  Future<AddressParts?> fetchPartsFromPlaceId(String placeId) async {
    final res = await _gp.details.get(placeId);
    final d = res?.result;
    if (d == null) return null;

    final loc = d.geometry?.location;
    final formatted = d.formattedAddress ?? d.name ?? '';
    // Convert Google address components -> state/city/postal
    final comp = _componentsToParts(d.addressComponents ?? []);
    return AddressParts(
      formattedAddress: formatted,
      state: comp['state'],
      city: comp['city'],
      postalCode: comp['postal'],
      lat: loc?.lat?.toDouble(),
      lng: loc?.lng?.toDouble(),
    );
  }

  /// Reverse geocoding -> AddressParts (using device lat/lng)
  Future<AddressParts?> reverseGeocode(double lat, double lng) async {
    final placemarks = await geo.placemarkFromCoordinates(lat, lng);
    if (placemarks.isEmpty) return null;

    final p = placemarks.first;
    final formatted = [
      p.street,
      p.subLocality,
      p.locality,
      p.administrativeArea,
      p.postalCode,
      p.country
    ].where((e) => e != null && e!.trim().isNotEmpty).join(', ');

    return AddressParts(
      formattedAddress: formatted,
      state: p.administrativeArea,
      city: p.locality ?? p.subAdministrativeArea,
      postalCode: p.postalCode,
      lat: lat,
      lng: lng,
    );
  }

  /// Helper: parse Google's AddressComponent list
  Map<String, String?> _componentsToParts(List<AddressComponent> comps) {
    String? state, city, postal;
    for (final c in comps) {
      final types = c.types ?? [];
      if (types.contains('administrative_area_level_1')) {
        state = c.longName;
      } else if (types.contains('locality') ||
          types.contains('administrative_area_level_2')) {
        city = c.longName;
      } else if (types.contains('postal_code')) {
        postal = c.longName;
      }
    }
    return {
      'state': state,
      'city': city,
      'postal': postal,
    };
  }
}
