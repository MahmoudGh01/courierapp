// lib/arrange_delivery/steps/pickup_step.dart
import 'package:courier_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../../Components/continue_button.dart';
import '../../Components/map_selector.dart';
import '../../Components/map_selector_controller.dart';
import '../../Components/place_search_field.dart';
import '../../Service/google_places_service.dart';
import '../../Service/address_parts.dart';
import '../../Theme/colors.dart';
import '../../Theme/style.dart';
import '../../ViewModels/quick_request_provider.dart';
import '../../locale/locales.dart';

class PickupStep extends StatefulWidget {
  final VoidCallback onContinue;
  const PickupStep({super.key, required this.onContinue});

  @override
  State<PickupStep> createState() => _PickupStepState();
}

class _PickupStepState extends State<PickupStep> {
  final _stateCtrl  = TextEditingController();
  final _cityCtrl   = TextEditingController();
  final _postalCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  final _places        = GooglePlacesService(Constants.googleApiKey);
  final _mapController = MapSelectorController();

  LatLng? _currentCenter;
  bool _locating = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return _useFallback();

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return _useFallback();
      }
      if (permission == LocationPermission.deniedForever) return _useFallback();

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentCenter = LatLng(pos.latitude, pos.longitude);
        _locating = false;
      });
    } catch (_) {
      _useFallback();
    }

    if (_currentCenter != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.moveTo(_currentCenter!, zoom: 15);
      });
    }
  }

  void _useFallback() {
    setState(() {
      _currentCenter = const LatLng(36.8065, 10.1815); // Tunis
      _locating = false;
    });
  }

  @override
  void dispose() {
    _stateCtrl.dispose();
    _cityCtrl.dispose();
    _postalCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme  = Theme.of(context);

    if (_locating) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Background map only
        Positioned.fill(
          child: MapSelector(
            initial: _currentCenter!,
            controller: _mapController,
            onPicked: (latLng) async {
              final parts = await _places.reverseGeocode(latLng.latitude, latLng.longitude);
              if (parts != null) {
                _stateCtrl.text  = parts.state ?? '';
                _cityCtrl.text   = parts.city ?? '';
                _postalCtrl.text = parts.postalCode ?? '';

                context.read<QuickRequestProvider>().updateOrigin(
                  address: parts.formattedAddress,
                  lat: latLng.latitude,
                  lng: latLng.longitude,
                  state: _stateCtrl.text,
                  city: _cityCtrl.text,
                  postalCode: _postalCtrl.text,
                );
              } else {
                context.read<QuickRequestProvider>().updateOrigin(
                  address: '',
                  lat: latLng.latitude,
                  lng: latLng.longitude,
                );
              }
            },
          ),
        ),

        // Top autocomplete
        Positioned(
          left: 16,
          right: 10,
          top: 12,
          child: Container(
            decoration: BoxDecoration(boxShadow: [boxShadow], color: Colors.white, borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: PlaceSearchField(
              service: _places,
              controller: _searchCtrl,
              hintText: locale.pickupHint,
              onPlaceResolved: (AddressParts parts) {
                if (parts.lat != null && parts.lng != null) {
                  _mapController.moveTo(LatLng(parts.lat!, parts.lng!), zoom: 16);
                }
                _stateCtrl.text  = parts.state ?? '';
                _cityCtrl.text   = parts.city ?? '';
                _postalCtrl.text = parts.postalCode ?? '';

                context.read<QuickRequestProvider>().updateOrigin(
                  address: parts.formattedAddress,
                  lat: parts.lat,
                  lng: parts.lng,
                  state: _stateCtrl.text,
                  city: _cityCtrl.text,
                  postalCode: _postalCtrl.text,
                );
              },
            ),
          ),
        ),

        // Bottom form
        Positioned(
          left: 16,
          right: 10,
          bottom: 8,
          child: Container(
            decoration: BoxDecoration(color: kWhiteColor, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _filledField(theme, label: 'State', controller: _stateCtrl, onChanged: (v) {
                  context.read<QuickRequestProvider>().updateOrigin(state: v);
                }),
                const SizedBox(height: 4),
                _filledField(theme, label: 'City', controller: _cityCtrl, onChanged: (v) {
                  context.read<QuickRequestProvider>().updateOrigin(city: v);
                }),
                const SizedBox(height: 4),
                _filledField(theme, label: 'Postal Code', controller: _postalCtrl, keyboard: TextInputType.number, onChanged: (v) {
                  context.read<QuickRequestProvider>().updateOrigin(postalCode: v);
                }),
                const SizedBox(height: 8),
                CustomButton(
                  radius: BorderRadius.circular(35.0),
                  padding: 10,
                  text: '     ${locale.continueText}  ↓    ',
                  onPressed: () {
                    final q = context.read<QuickRequestProvider>();
                    final valid = q.originAddress.isNotEmpty &&
                        q.originCity.isNotEmpty &&
                        q.originState.isNotEmpty &&
                        q.originPostalCode.isNotEmpty &&
                        q.originLatitude != null &&
                        q.originLongitude != null;
                    if (!valid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('locale.pleaseEnterAllDetails')),
                      );
                      return;
                    }
                    widget.onContinue();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _filledField(
      ThemeData theme, {
        required String label,
        TextEditingController? controller,
        TextInputType? keyboard,
        required ValueChanged<String> onChanged,
      }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: kButtonColor,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
