import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_selector_controller.dart';

class MapSelector extends StatefulWidget {
  final LatLng initial;                           // initial camera target
  final Function(LatLng) onPicked;                // called when camera idles
  final MapSelectorController? controller;        // external controller (optional)

  // Optional visual tuning (non-breaking additions)
  final double? height;                           // if null => expands to parent
  final BorderRadius? radius;                     // rounded corners (optional)
  final MapType mapType;                          // normal/hybrid/satellite/terrain

  const MapSelector({
    super.key,
    required this.initial,
    required this.onPicked,
    this.controller,
    this.height,
    this.radius,
    this.mapType = MapType.normal,
  });

  @override
  State<MapSelector> createState() => _MapSelectorState();
}

class _MapSelectorState extends State<MapSelector> {
  GoogleMapController? _gmaps;

  // Live camera target while dragging.
  late LatLng _cameraTarget;

  // Last "picked" value (committed on onCameraIdle).
  late LatLng _picked;

  @override
  void initState() {
    super.initState();
    _cameraTarget = widget.initial;
    _picked       = widget.initial;

    // Bind external controller (used by search/autocomplete to re-center)
    widget.controller?.bind((LatLng target, {double zoom = 15}) async {
      if (_gmaps != null) {
        await _gmaps!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: zoom),
          ),
        );
        // Keep local states in sync
        setState(() {
          _cameraTarget = target;
          _picked = target;
        });
        // Notify parent about the new picked center
        widget.onPicked(target);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final map = GoogleMap(
      mapType: widget.mapType,
      initialCameraPosition: CameraPosition(target: widget.initial, zoom: 14),
      onMapCreated: (c) => _gmaps = c,
      // Enable free movement
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomControlsEnabled: true,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,

      // Track center while panning
      onCameraMove: (CameraPosition pos) {
        _cameraTarget = pos.target;
      },

      // Commit selection when user stops moving
      onCameraIdle: () {
        setState(() => _picked = _cameraTarget);
        widget.onPicked(_picked);
      },

      // Optional: tap to jump/animate camera to tapped point
      onTap: (LatLng p) async {
        if (_gmaps != null) {
          await _gmaps!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: p, zoom: 16),
            ),
          );
        }
      },
    );

    // Crosshair marker at the center (selected point)
    final crosshair = IgnorePointer(
      ignoring: true,
      child: Center(
        child: Icon(
          Icons.place,
          color: Theme.of(context).primaryColor,
          size: 34,
        ),
      ),
    );

    // (Optional) small coordinate badge at bottom
    final coordBadge = Positioned(
      bottom: 10,
      left: 12,
      right: 12,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Lat: ${_picked.latitude.toStringAsFixed(6)} • Lng: ${_picked.longitude.toStringAsFixed(6)}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );

    Widget content = Stack(
      fit: StackFit.expand,
      children: [
        map,
        crosshair,
        coordBadge,
      ],
    );

    // Apply optional rounded corners + height
    if (widget.radius != null) {
      content = ClipRRect(borderRadius: widget.radius!, child: content);
    }
    if (widget.height != null) {
      content = SizedBox(height: widget.height, child: content);
    } else {
      content = SizedBox.expand(child: content);
    }

    return content;
  }
}
