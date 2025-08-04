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

  const MapWidget({super.key, this.child, this.addMarkers = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderMapBloc>(
      create: (context) => OrderMapBloc()..loadMap(),
      child: MapWidgetBody(
        addMarkers: addMarkers,
        child: child,
      ),
    );
  }
}

class MapWidgetBody extends StatefulWidget {
  final bool addMarkers;
  final Widget? child;

  const MapWidgetBody({super.key, this.child, required this.addMarkers});

  @override
  State<MapWidgetBody> createState() => _MapWidgetBodyState();
}

class _MapWidgetBodyState extends State<MapWidgetBody> {
  final Completer<GoogleMapController> _mapController = Completer();

  GoogleMapController? mapStyleController;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    rootBundle.loadString('images/map_style.txt').then((string) {
      mapStyle = string;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          BlocBuilder<OrderMapBloc, OrderMapState>(builder: (context, state) {
            Printer.debugPrint('polyyyy${state.polylines}');
            return GoogleMap(
              // polylines: state.polylines,
              mapType: MapType.normal,
              initialCameraPosition: kGooglePlex,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) async {
                _mapController.complete(controller);
                mapStyleController = controller;
                mapStyleController!.setMapStyle(mapStyle);
                if (widget.addMarkers) {
                  setState(() {
                    _markers.add(
                      Marker(
                        markerId: const MarkerId('mark1'),
                        position:
                            const LatLng(37.42796133580664, -122.085749655962),
                        icon: markerss.first,
                      ),
                    );
                    _markers.add(
                      Marker(
                        markerId: const MarkerId('mark2'),
                        position:
                            const LatLng(37.42496133180663, -122.081743655960),
                        icon: markerss[1],
                      ),
                    );
                    // _markers.add(
                    //   Marker(
                    //     markerId: const MarkerId('mark3'),
                    //     position:
                    //         const LatLng(37.42196183580660, -122.089743655967),
                    //     icon: markerss[2],
                    //   ),
                    // );
                  });
                }
              },
            );
          }),
          widget.child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
