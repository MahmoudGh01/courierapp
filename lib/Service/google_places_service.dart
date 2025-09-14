// lib/Service/google_places_service.dart
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_places_flutter/model/prediction.dart';

import 'address_parts.dart';

class GooglePlacesService {
  final String apiKey;
  GooglePlacesService(this.apiKey);

  /// Convert a Prediction (with lat/lng from google_places_flutter) to AddressParts.
  /// If lat/lng available, we reverse geocode to get state/city/postal.
  Future<AddressParts?> predictionToAddressParts(Prediction p) async {
    final double? lat = p.lat != null ? double.tryParse(p.lat!) : null;
    final double? lng = p.lng != null ? double.tryParse(p.lng!) : null;


    String formatted = p.description ?? '';
    String? state, city, postal;

    if (lat != null && lng != null) {
      final rev = await reverseGeocode(lat, lng);
      state = rev?.state;
      city = rev?.city;
      postal = rev?.postalCode;
      // if formatted is empty (rare), fallback to reverse formatted
      if (formatted.isEmpty && rev?.formattedAddress != null) {
        formatted = rev!.formattedAddress!;
      }
    }

    return AddressParts(
      formattedAddress: formatted,
      state: state,
      city: city,
      postalCode: postal,
      lat: lat,
      lng: lng,
    );
  }

  /// Reverse geocoding using geocoding package -> AddressParts
  Future<AddressParts?> reverseGeocode(double lat, double lng) async {
    try {
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
    } catch (_) {
      return null;
    }
  }
}
