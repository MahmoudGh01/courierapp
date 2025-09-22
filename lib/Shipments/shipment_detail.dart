import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/map_widget.dart';
import 'package:courier_app/Models/shipment_model.dart';
import 'package:courier_app/Models/transport_request_model.dart';
import 'package:courier_app/Models/quick_transport_request_model.dart';
import 'package:courier_app/Shipments/shipment_slide_up_panel.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ShipmentDetailPage extends StatefulWidget {
  final Shipment shipment;

  const ShipmentDetailPage({super.key, required this.shipment});

  @override
  State<ShipmentDetailPage> createState() => _ShipmentDetailPageState();
}

class _ShipmentDetailPageState extends State<ShipmentDetailPage> {
  @override
  Widget build(BuildContext context) {
    final s = widget.shipment;
    final theme = Theme.of(context);
    final statusColor = _statusColor(s.status.name);

    // pick transport or quick request
    final TransportRequestModel? tReq = s.transportRequest;
    final QuickTransportRequestModel? qReq = s.quickTransportRequest;

    String getServiceType() =>
        tReq?.serviceType ?? qReq?.serviceType ?? "Shipment";

    String getOriginAddress() =>
        tReq?.originAddress ?? qReq?.originAddress ?? "—";

    String getDestinationAddress() =>
        tReq?.destinationAddress ?? qReq?.destinationAddress ?? "—";

    double getOriginLat() =>
        tReq?.originLatitude ?? qReq?.originLatitude ?? 0;

    double getOriginLng() =>
        tReq?.originLongitude ?? qReq?.originLongitude ?? 0;

    double getDestLat() =>
        tReq?.destinationLatitude ?? qReq?.destinationLatitude ?? 0;

    double getDestLng() =>
        tReq?.destinationLongitude ?? qReq?.destinationLongitude ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: AppBar(
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios, size: 24.0),
            ),
            title: FadedScaleAnimation(child: const Text('Shipment Detail')),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          // --- Shipment Header Card ---
          Container(
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                  statusColor.withOpacity(0.10), theme.colorScheme.surface),
              borderRadius: BorderRadius.circular(12),
              border: Border(
                  left: BorderSide(
                      color: statusColor.withOpacity(0.65), width: 4)),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsetsDirectional.only(top: 4, bottom: 4, end: 16),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              leading: FadedScaleAnimation(
                  child: Image.asset("images/home1.png")),
              title: Text(
                "#SHP-${s.idShipment}",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.access_time,
                      size: 14, color: statusColor.withOpacity(0.7)),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat.yMMMd().add_jm().format(s.createdAt),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.hintColor.withOpacity(0.8),
                      height: 1.5,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    s.status.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // --- Map with Slide Panel ---
          Expanded(
            child: MapWidget(
              addMarkers: true,
              origin: LatLng(getOriginLat(), getOriginLng()),
              destination: LatLng(getDestLat(), getDestLng()),
              child: ShipmentSlideUpPanel(
                shipment: s,
                serviceType: getServiceType(),
                originAddress: getOriginAddress(),
                destinationAddress: getDestinationAddress(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(String status) {
  final s = status.toLowerCase();
  if (s.contains('confirmed')) return const Color(0xFFfb8c00);
  if (s.contains('dispatched') || s.contains('in_transit'))
    return const Color(0xFF1e88e5);
  if (s.contains('delivered') || s.contains('completed'))
    return const Color(0xFF43a047);
  if (s.contains('failed')) return const Color(0xFFe53935);
  return kMainColor;
}
