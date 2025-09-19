import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/map_widget.dart';
import 'package:courier_app/Models/transport_request_model.dart';
import 'package:courier_app/Pages/slide_up_panel.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackDelivery extends StatefulWidget {
  final TransportRequestModel item;
  const TrackDelivery({super.key, required this.item});

  @override
  State<TrackDelivery> createState() => _TrackDeliveryState();
}

class _TrackDeliveryState extends State<TrackDelivery> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    final m = widget.item;
    final statusColor = _statusColor(widget.item.status);
    final theme = Theme.of(context); // theme shortcut

    return Scaffold(
      drawerScrimColor: Colors.white,
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
            title: FadedScaleAnimation(child: const Text('Transport Request')),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          // --- Card header with model data ---
          Container(
            decoration: BoxDecoration(
              // 👉 Tinted surface: blends status color into the surface for a subtle background tint
              color: Color.alphaBlend(statusColor.withOpacity(0.10),
                  theme.colorScheme.surface), // tint bg
              borderRadius: BorderRadius.circular(12), // keep radius
              // 👉 Left accent bar reflecting status (thin, elegant)
              border: Border(
                  left: BorderSide(
                      color: statusColor.withOpacity(0.65),
                      width: 4)), // status bar
              // 👉 Soft glow matching status for depth (optional but nice)
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.12), // colored shadow
                  blurRadius: 12, // softness
                  offset: const Offset(0, 6), // drop
                ),
              ],
            ),
            padding: const EdgeInsetsDirectional.only(
                top: 4, bottom: 4, end: 16), // same paddings
            margin:
                const EdgeInsets.symmetric(horizontal: 10.0), // same margins
            child: ListTile(
              contentPadding: EdgeInsets.zero, // unchanged
              leading: FadedScaleAnimation(
                  child: Image.asset("images/home1.png")), // unchanged
              title: Text(
                "#TR-${widget.item.idTransportRequest}", // unchanged title
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold, // unchanged weight
                  fontSize: 16, // unchanged size
                ),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.access_time,
                      size: 14,
                      color: statusColor.withOpacity(0.7)), // ⏰ matches status
                  const SizedBox(width: 6), // small gap
                  Text(
                    (widget.item.createdAt ?? DateTime.now())
                        .toLocal()
                        .toString()
                        .split('.')
                        .first, // unchanged date
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.hintColor.withOpacity(0.8), // softer neutral
                      height: 1.5, // unchanged
                      fontSize: 12, // unchanged
                    ),
                  ),
                  const Spacer(), // unchanged
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // unchanged
                mainAxisAlignment: MainAxisAlignment.center, // unchanged
                children: [
                  // 👉 Status text uses the same mapped color
                  Text(
                    widget.item.status, // status label
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: statusColor, // colored by status
                      fontWeight: FontWeight.bold, // unchanged
                      fontSize: 16, // unchanged
                    ),
                  ),
                  const SizedBox(height: 4), // unchanged
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          Expanded(
            child: MapWidget(
                addMarkers: true,
                child: SlideUpPanel(item: m),
                origin: LatLng(m.originLatitude!, m.originLongitude!),
                destination:
                    LatLng(m.destinationLatitude!, m.destinationLongitude!)),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(String status) {
  final s = status.toLowerCase(); // normalize
  if (s.contains('pending')) return const Color(0xFFfb8c00); // orange
  if (s.contains('accepted') || s.contains('published'))
    return const Color(0xFF1e88e5); // blue
  if (s.contains('in') && s.contains('transit'))
    return const Color(0xFF7e57c2); // purple
  if (s.contains('delivered') || s.contains('completed'))
    return const Color(0xFF43a047); // green
  if (s.contains('canceled') || s.contains('rejected'))
    return const Color(0xFFe53935); // red
  return kMainColor; // default accent
}
