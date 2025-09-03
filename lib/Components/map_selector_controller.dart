import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelectorController {
  void Function(LatLng target, {double zoom})? _moveTo;

  // Bound by MapSelector
  void bind(void Function(LatLng, {double zoom}) mover) {
    _moveTo = mover;
  }

  // Call this to move/zoom the map programmatically (e.g. after search).
  void moveTo(LatLng target, {double zoom = 15}) {
    _moveTo?.call(target, zoom: zoom);
  }
}
