import 'dart:async';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../map_utils.dart';        // provides: apiKey, markerss
import 'order_map_state.dart';     // your state (Set<Polyline>, Set<Marker>)

class OrderMapBloc extends Cubit<OrderMapState> {
  OrderMapBloc() : super(const OrderMapState({}, {}));

  /// Load route polyline + markers
  Future<void> loadMap({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final Set<Polyline> polylines = {};
    final Set<Marker> markersSet = {};

    // --- Polyline ---
    final polyline = await _getPolyLine(origin, destination);
    polylines.add(polyline);

    // --- Markers ---
    markersSet.add(
      Marker(
        markerId: const MarkerId('origin'),
        position: origin,
        icon: markerss.isNotEmpty
            ? markerss.first
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Pickup'),
      ),
    );
    markersSet.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        icon: markerss.length > 1
            ? markerss[1]
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Drop-off'),
      ),
    );

    emit(OrderMapState(polylines, markersSet));
  }

  // Build a polyline from Google Directions API
  Future<Polyline> _getPolyLine(LatLng origin, LatLng destination) async {
    const id = PolylineId('poly');
    final points = await _getPolylineCoordinates(origin, destination);

    return Polyline(
      polylineId: id,
      width: 4,
      points: points,
      color: const Color(0xFF0A84FF), // iOS blue-ish
      geodesic: true,
      visible: points.isNotEmpty,
    );
  }

  Future<List<LatLng>> _getPolylineCoordinates(
      LatLng pickupLatLng,
      LatLng dropLatLng,
      ) async {
    final List<LatLng> polylineCoordinates = [];

    try {
      final polylinePoints = PolylinePoints(
        apiKey: apiKey, // from map_utils.dart
        defaultTimeout: const Duration(seconds: 30),
        preferRoutesApi: true,
      );

      final req = PolylineRequest(
        origin: PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        destination: PointLatLng(dropLatLng.latitude, dropLatLng.longitude),
        mode: TravelMode.driving,
      );

      final result =
      await polylinePoints.getRouteBetweenCoordinates(request: req);

      if (result.points.isNotEmpty) {
        for (final p in result.points) {
          polylineCoordinates.add(LatLng(p.latitude, p.longitude));
        }
      } else {
        print(
            'Polyline empty. status: ${result.status} | message: ${result.errorMessage}');
      }
    } catch (e) {
      print('Polyline exception: $e');
    }

    print('Polyline coords count: ${polylineCoordinates.length}');
    return polylineCoordinates;
  }
}
