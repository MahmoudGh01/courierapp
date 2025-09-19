// lib/Components/map_widget.dart
import 'dart:async';

import 'package:courier_app/OrderMapBloc/order_map_bloc.dart';
import 'package:courier_app/OrderMapBloc/order_map_state.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/map_utils.dart';
import 'package:courier_app/utils/printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final Widget? child;
  final bool addMarkers;
  final LatLng? origin;       // ✅ direct pickup
  final LatLng? destination;  // ✅ direct delivery

  const MapWidget({
    super.key,
    this.child,
    this.addMarkers = false,
    this.origin,
    this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderMapBloc>(
      create: (context) => OrderMapBloc()
        ..loadMap(origin: origin!, destination: destination!),   // ✅ load polyline + markers
      child: MapWidgetBody(
        addMarkers: addMarkers,
        child: child,
        origin: origin,
        destination: destination,
      ),
    );
  }
}

class MapWidgetBody extends StatefulWidget {
  final bool addMarkers;
  final Widget? child;
  final LatLng? origin;
  final LatLng? destination;

  const MapWidgetBody({
    super.key,
    this.child,
    required this.addMarkers,
    this.origin,
    this.destination,
  });

  @override
  State<MapWidgetBody> createState() => _MapWidgetBodyState();
}

class _MapWidgetBodyState extends State<MapWidgetBody> {
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? _gm;
  final Set<Marker> _markers = {};
  bool _seeded = false; // ✅ prevent double-adding

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('images/map_style.txt').then((s) => mapStyle = s);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          BlocBuilder<OrderMapBloc, OrderMapState>(
            builder: (context, state) {
              Printer.debugPrint('polyyyy${state.polylines}');
              return GoogleMap(
                polylines: state.polylines,
                mapType: MapType.hybrid,
                initialCameraPosition: kGooglePlex,
                markers: _markers,
                onMapCreated: (GoogleMapController c) async {
                  _mapController.complete(c);
                  _gm = c;
                  _gm!.setMapStyle(mapStyle);

                  // ✅ Seed markers/camera once
                  if (!_seeded &&
                      widget.addMarkers &&
                      widget.origin != null &&
                      widget.destination != null) {
                    _seeded = true;
                    _seedMarkersAndCamera(widget.origin!, widget.destination!);
                  }
                },
              );
            },
          ),
          widget.child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  // ✅ Add origin/destination markers and fit camera to bounds
  Future<void> _seedMarkersAndCamera(LatLng origin, LatLng dest) async {
    setState(() {
      _markers
        ..add(Marker(
          markerId: const MarkerId('origin'),
          position: origin,
          icon: ( BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)),
          infoWindow: const InfoWindow(title: 'Pickup'),
        ))
        ..add(Marker(
          markerId: const MarkerId('destination'),
          position: dest,
          icon: (BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
          infoWindow: const InfoWindow(title: 'Drop-off'),
        ));
    });

    final bounds = _boundsFromLatLngs([origin, dest]);
    await _fitBounds(bounds, padding: 60);
  }

  // ✅ Compute bounds from points
  LatLngBounds _boundsFromLatLngs(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (final LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      southwest: LatLng(x0!, y0!),
      northeast: LatLng(x1!, y1!),
    );
  }

  // ✅ Animate camera to bounds
  Future<void> _fitBounds(LatLngBounds b, {int padding = 50}) async {
    if (_gm == null) return;
    try {
      final update = CameraUpdate.newLatLngBounds(b, padding.toDouble());
      await _gm!.animateCamera(update);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 100));
      try {
        await _gm!.animateCamera(CameraUpdate.newLatLngBounds(b, padding.toDouble()));
      } catch (_) {}
    }
  }
}
