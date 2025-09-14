import 'dart:async';

import 'package:courier_app/utils/printer.dart';            // custom logger
import 'package:flutter_bloc/flutter_bloc.dart';             // Bloc/Cubit base
import 'package:flutter_polyline_points/flutter_polyline_points.dart'; // polyline decoder + Directions
import 'package:google_maps_flutter/google_maps_flutter.dart';         // Google Map types

import '../map_utils.dart';                                  // provides: apiKey, markerss
import 'order_map_state.dart';                               // your state (Set<Polyline>, Set<Marker>)

class OrderMapBloc extends Cubit<OrderMapState> {
  // init state with empty polylines/markers
  OrderMapBloc() : super(const OrderMapState({}, {}));

  // public: load map data (markers + polyline) then emit state
  void loadMap() async {
    final Set<Polyline> polylines = {};                      // prepare container for polylines
    final polyline = await _getPolyLine();                   // build main route polyline
    final Set<Marker> markersSet = {};                       // container for markers
    markersSet.addAll(markers);                              // add predefined markers
    polylines.add(polyline);                                 // add route to set
    emit(OrderMapState(polylines, markersSet));              // push state to UI
  }

  // helper: build a Polyline widget from decoded points
  Future<Polyline> _getPolyLine() async {
    const id = PolylineId('poly');                           // stable id for the route
    final points = await _getPolylineCoordinates(            // decode route coordinates
      const LatLng(37.42796133580664, -122.085749655962),    // origin: sample 1
      const LatLng(37.42496133180663, -122.081743655960),    // destination: sample 2
    );

    return Polyline(
      polylineId: id,                                        // assign id
      width: 4,                                              // stroke width
      points: points,                                        // decoded path
      geodesic: true,                                        // better curvature
      visible: points.isNotEmpty,                            // hide if empty
    );
  }

  Future<List<LatLng>> _getPolylineCoordinates(
      LatLng pickupLatLng,
      LatLng dropLatLng,
      ) async {
    final List<LatLng> polylineCoordinates = [];

    try {
      // 1) init with your Google API key
      final polylinePoints = PolylinePoints(
        apiKey: apiKey,                        // <-- your key
        defaultTimeout: const Duration(seconds: 30),
        preferRoutesApi: true,                 // set to false if you only enabled "Directions API"
      );

      // 2) build request
      final req = PolylineRequest(
        origin: PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        destination: PointLatLng(dropLatLng.latitude, dropLatLng.longitude),
        mode: TravelMode.driving,
      );

      // 3) call
      final result = await polylinePoints.getRouteBetweenCoordinates(request: req);

      // 4) map decoded points
      if (result.points.isNotEmpty) {
        for (final p in result.points) {
          polylineCoordinates.add(LatLng(p.latitude, p.longitude));
        }
      } else {
        // result.errorMessage may contain: "API key not valid for Routes API", quota, etc.
        print('Polyline empty. status: ${result.status} | message: ${result.errorMessage}');
      }
    } catch (e) {
      print('Polyline exception: $e');
    }

    print('Polyline coords count: ${polylineCoordinates.length}');
    return polylineCoordinates;
  }
  // demo markers (icons come from map_utils.dart -> markerss)
  final List<Marker> markers = [
    Marker(
      markerId: const MarkerId('mark1'),                  // unique id
      position: const LatLng(37.42796133580664, -122.085749655962), // position #1
      icon: markerss.first,                               // custom icon (BitmapDescriptor)
    ),
    Marker(
      markerId: const MarkerId('mark2'),                  // unique id
      position: const LatLng(37.42496133180663, -122.081743655960), // position #2
      icon: markerss[1],                                  // custom icon (BitmapDescriptor)
    ),
  ];
}
