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

  // core: call Directions via flutter_polyline_points and decode the path
  Future<List<LatLng>> _getPolylineCoordinates(
      LatLng pickupLatLng,
      LatLng dropLatLng,
      ) async {
    final List<LatLng> polylineCoordinates = [];             // accumulator for LatLngs
    final polylinePoints = PolylinePoints();                 // client instance

    try {
      // IMPORTANT: ^2.x API -> positional params: (apiKey, origin, destination, {travelMode,...})
      final result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,                                              // your Google Directions API key
        PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude), // origin
        PointLatLng(dropLatLng.latitude, dropLatLng.longitude),     // destination
        travelMode: TravelMode.driving,                      // optional: driving/walking/bicycling
      );

      // if the service returned points, map them to LatLng
      if (result.points.isNotEmpty) {
        for (final p in result.points) {
          polylineCoordinates.add(LatLng(p.latitude, p.longitude));  // push each decoded point
        }
      } else {
        // log any backend error from plugin (quota, key restrictions, etc.)
        Printer.debugPrint('Polyline empty. Message: ${result.errorMessage}');
      }
    } catch (e) {
      // catch unexpected exceptions (network off, bad key variable, etc.)
      Printer.debugPrint('Polyline exception: $e');
    }

    Printer.debugPrint('Polyline coords count: ${polylineCoordinates.length}'); // debug length
    return polylineCoordinates;                                   // return decoded list
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
