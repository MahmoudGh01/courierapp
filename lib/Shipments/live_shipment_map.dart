import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../ViewModels/shipment_provider.dart';

class LiveShipmentMap extends StatelessWidget {
  final int shipmentId;


  const LiveShipmentMap(
      {super.key, required this.shipmentId});


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShipmentProvider>();
    final location = provider.driverLocation;

    return GoogleMap(
      initialCameraPosition:
          const CameraPosition(target: LatLng(0, 0), zoom: 12),
      markers: {
        if (location != null)
          Marker(markerId: const MarkerId("driver"), position: location),
      },
    );
  }
}
