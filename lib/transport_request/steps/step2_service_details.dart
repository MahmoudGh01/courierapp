import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../Theme/colors.dart';
import '../../Theme/style.dart';
import '../../Service/google_places_service.dart';
import '../../Components/place_search_field.dart';
import '../../Components/map_selector.dart';
import '../../Components/map_selector_controller.dart';
import '../../ViewModels/transport_request_provider.dart';
import '../../Models/enums.dart';
import '../../utils/constants.dart';

class Step2ServiceDetails extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const Step2ServiceDetails({super.key, required this.onNext, required this.onBack});

  @override
  State<Step2ServiceDetails> createState() => _Step2ServiceDetailsState();
}

class _Step2ServiceDetailsState extends State<Step2ServiceDetails> {
  final _places = GooglePlacesService(Constants.googleApiKey);
  final _mapCtrl = MapSelectorController();

  LatLng? _center;
  bool _locating = true;

  // Origin fields
  final _originState = TextEditingController();
  final _originCity = TextEditingController();
  final _originPostal = TextEditingController();
  final _originSearch = TextEditingController();
  final _originFloor = TextEditingController(text: '0');
  bool _originElevator = false;

  // Destination fields
  final _destState = TextEditingController();
  final _destCity = TextEditingController();
  final _destPostal = TextEditingController();
  final _destSearch = TextEditingController();
  final _destFloor = TextEditingController(text: '0');
  bool _destElevator = false;

  // Scheduling
  DateTime? _pickDate;
  DateTime? _delivDate;
  TimeOfDay? _pickTime;
  TimeOfDay? _delivTime;

  final _pFlexDays  = TextEditingController(text: '0');
  final _pFlexHours = TextEditingController(text: '0');
  final _dFlexDays  = TextEditingController(text: '0');
  final _dFlexHours = TextEditingController(text: '0');

  // Dismantling
  bool _needDismantle = false;
  DismantlingType? _dismantleType = DismantlingType.NONE;
  final _pieces = TextEditingController(text: '0');

  // Which side we are editing on the SAME map (origin/destination)
  bool _editOrigin = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return _fallback();
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        return _fallback();
      }
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _center = LatLng(pos.latitude, pos.longitude);
        _locating = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapCtrl.moveTo(_center!, zoom: 15);
      });
    } catch (_) {
      _fallback();
    }
  }

  void _fallback() {
    setState(() {
      _center = const LatLng(36.8065, 10.1815); // Tunis
      _locating = false;
    });
  }

  @override
  void dispose() {
    _originState.dispose();
    _originCity.dispose();
    _originPostal.dispose();
    _originSearch.dispose();
    _originFloor.dispose();

    _destState.dispose();
    _destCity.dispose();
    _destPostal.dispose();
    _destSearch.dispose();
    _destFloor.dispose();

    _pFlexDays.dispose();
    _pFlexHours.dispose();
    _dFlexDays.dispose();
    _dFlexHours.dispose();
    _pieces.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p     = context.watch<TransportRequestProvider>();
    final theme = Theme.of(context);

    if (_locating) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // === Background: Single MapSelector ===
        Positioned.fill(
          child: MapSelector(
            initial: _center!,
            controller: _mapCtrl,
            onPicked: (latLng) async {
              final parts = await _places.reverseGeocode(latLng.latitude, latLng.longitude);
              if (_editOrigin) {
                _originState.text  = parts?.state ?? '';
                _originCity.text   = parts?.city ?? '';
                _originPostal.text = parts?.postalCode ?? '';
                p.setOrigin(
                  address: parts?.formattedAddress,
                  state:   _originState.text,
                  city:    _originCity.text,
                  postal:  _originPostal.text,
                  lat:     latLng.latitude,
                  lng:     latLng.longitude,
                );
              } else {
                _destState.text  = parts?.state ?? '';
                _destCity.text   = parts?.city ?? '';
                _destPostal.text = parts?.postalCode ?? '';
                p.setDestination(
                  address: parts?.formattedAddress,
                  state:   _destState.text,
                  city:    _destCity.text,
                  postal:  _destPostal.text,
                  lat:     latLng.latitude,
                  lng:     latLng.longitude,
                );
              }
            },
          ),
        ),

        // === Slide-Up Panel ===
        DraggableScrollableSheet(
          minChildSize: 0.25,
          initialChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [boxShadow],
                color: kWhiteColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(35.0)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                children: [
                  // --- Pull handle ---
                  Center(
                    child: Container(
                      width: 48, height: 5,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: theme.dividerColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),

                  // --- Toggle: Origin / Destination ---
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Origin'),
                        selected: _editOrigin,
                        onSelected: (_) => setState(() => _editOrigin = true),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Destination'),
                        selected: !_editOrigin,
                        onSelected: (_) => setState(() => _editOrigin = false),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Center to current',
                        onPressed: () { if (_center != null) _mapCtrl.moveTo(_center!, zoom: 15); },
                        icon: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // --- PlaceSearchField ---
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [boxShadow],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: PlaceSearchField(
                      service: _places,
                      controller: _editOrigin ? _originSearch : _destSearch,
                      hintText: _editOrigin ? 'Pickup address' : 'Delivery address',
                      onPlaceResolved: (parts) {
                        final lat = parts.lat;
                        final lng = parts.lng;
                        if (lat != null && lng != null) {
                          _mapCtrl.moveTo(LatLng(lat, lng), zoom: 16);
                        }
                        if (_editOrigin) {
                          _originState.text  = parts.state ?? '';
                          _originCity.text   = parts.city ?? '';
                          _originPostal.text = parts.postalCode ?? '';
                          p.setOrigin(
                            address: parts.formattedAddress,
                            state:   _originState.text,
                            city:    _originCity.text,
                            postal:  _originPostal.text,
                            lat:     lat, lng: lng,
                          );
                        } else {
                          _destState.text  = parts.state ?? '';
                          _destCity.text   = parts.city ?? '';
                          _destPostal.text = parts.postalCode ?? '';
                          p.setDestination(
                            address: parts.formattedAddress,
                            state:   _destState.text,
                            city:    _destCity.text,
                            postal:  _destPostal.text,
                            lat:     lat, lng: lng,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- Address details: State / City / Postal / Floor / Elevator ---
                  Text(_editOrigin ? 'Origin Details' : 'Destination Details', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _filledField(
                          'State',
                          controller: _editOrigin ? _originState : _destState,
                          onChanged: (v) {
                            _editOrigin
                                ? context.read<TransportRequestProvider>().setOrigin(state: v)
                                : context.read<TransportRequestProvider>().setDestination(state: v);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _filledField(
                          'City',
                          controller: _editOrigin ? _originCity : _destCity,
                          onChanged: (v) {
                            _editOrigin
                                ? context.read<TransportRequestProvider>().setOrigin(city: v)
                                : context.read<TransportRequestProvider>().setDestination(city: v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _filledField(
                          'Postal Code',
                          controller: _editOrigin ? _originPostal : _destPostal,
                          keyboard: TextInputType.number,
                          onChanged: (v) {
                            _editOrigin
                                ? context.read<TransportRequestProvider>().setOrigin(postal: v)
                                : context.read<TransportRequestProvider>().setDestination(postal: v);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _filledField(
                          _editOrigin ? 'Departure floor' : 'Arrival floor',
                          controller: _editOrigin ? _originFloor : _destFloor,
                          keyboard: TextInputType.number,
                          onChanged: (v) {
                            final floor = int.tryParse(v) ?? 0;
                            _editOrigin
                                ? context.read<TransportRequestProvider>().setOrigin(floor: floor)
                                : context.read<TransportRequestProvider>().setDestination(floor: floor);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _editOrigin ? _originElevator : _destElevator,
                        onChanged: (val) {
                          setState(() {
                            if (_editOrigin) {
                              _originElevator = val ?? false;
                            } else {
                              _destElevator = val ?? false;
                            }
                          });
                          _editOrigin
                              ? context.read<TransportRequestProvider>().setOrigin(elevator: _originElevator)
                              : context.read<TransportRequestProvider>().setDestination(elevator: _destElevator);
                        },
                      ),
                      const Text('Elevator available (Optional)'),
                    ],
                  ),

                  const Divider(),

                  // --- Scheduling ---
                  Text('Pick-up & Delivery', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _dateBtn(
                          context,
                          label: 'Pick-up Date',
                          value: _pickDate,
                          onPicked: (d) {
                            setState(() => _pickDate = d);
                            context.read<TransportRequestProvider>().setScheduling(pickUpDate: d);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _dateBtn(
                          context,
                          label: 'Delivery Date',
                          value: _delivDate,
                          onPicked: (d) {
                            setState(() => _delivDate = d);
                            context.read<TransportRequestProvider>().setScheduling(deliveryDate: d);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: timeBtn(
                          context: context,
                          label: 'Pick-up Time',
                          value: _pickTime,
                          onPicked: (t) => setState(() => _pickTime = t),
                          use24h: true,
                          minuteStep: 5,
                        )
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: timeBtn(
                          context: context,
                          label: 'Delivery Time',
                          value: _delivTime,
                          onPicked: (t) => setState(() => _delivTime = t),
                          use24h: false,
                          minuteStep: 15,
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _filledField(
                          'Pick-up Flex (days)',
                          controller: _pFlexDays,
                          keyboard: TextInputType.number,
                          onChanged: (v) =>
                              context.read<TransportRequestProvider>().setScheduling(pickUpFlexDays: int.tryParse(v)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _filledField(
                          'Pick-up Flex (hours)',
                          controller: _pFlexHours,
                          keyboard: TextInputType.number,
                          onChanged: (v) =>
                              context.read<TransportRequestProvider>().setScheduling(pickUpFlexHours: int.tryParse(v)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _filledField(
                          'Delivery Flex (days)',
                          controller: _dFlexDays,
                          keyboard: TextInputType.number,
                          onChanged: (v) =>
                              context.read<TransportRequestProvider>().setScheduling(deliveryFlexDays: int.tryParse(v)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _filledField(
                          'Delivery Flex (hours)',
                          controller: _dFlexHours,
                          keyboard: TextInputType.number,
                          onChanged: (v) =>
                              context.read<TransportRequestProvider>().setScheduling(deliveryFlexHours: int.tryParse(v)),
                        ),
                      ),
                    ],
                  ),

                  const Divider(),

                  // --- Dismantling ---
                  Row(
                    children: [
                      Checkbox(
                        value: _needDismantle,
                        onChanged: (v) {
                          setState(() => _needDismantle = v ?? false);
                          context.read<TransportRequestProvider>().setDismantling(required: _needDismantle);
                        },
                      ),
                      const Text('Do you need to dismantle?'),
                    ],
                  ),
                  if (_needDismantle) ...[
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('All items'),
                          selected: _dismantleType == DismantlingType.ALL_ITEMS,
                          onSelected: (_) {
                            setState(() => _dismantleType = DismantlingType.ALL_ITEMS);
                            context.read<TransportRequestProvider>().setDismantling(type: _dismantleType.toString());
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Only certain items'),
                          selected: _dismantleType == DismantlingType.SOME_ITEMS,
                          onSelected: (_) {
                            setState(() => _dismantleType = DismantlingType.SOME_ITEMS);
                            context.read<TransportRequestProvider>().setDismantling(type: _dismantleType.toString());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _filledField(
                      'Number of pieces',
                      controller: _pieces,
                      keyboard: TextInputType.number,
                      onChanged: (v) =>
                          context.read<TransportRequestProvider>().setDismantling(pieces: int.tryParse(v)),
                    ),
                  ],

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton(onPressed: widget.onBack, child: const Text('Back')),
                      const Spacer(),
                      ElevatedButton(onPressed: widget.onNext, child: const Text('Continue  ↓')),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ------------------ Helpers ------------------

  Widget _filledField(
      String label, {
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

  Widget _dateBtn(
      BuildContext ctx, {
        required String label,
        required DateTime? value,
        required ValueChanged<DateTime> onPicked,
      }) {
    return OutlinedButton(
      onPressed: () async {
        final now = DateTime.now();
        final d = await showDatePicker(
          context: ctx,
          firstDate: now,
          lastDate: now.add(const Duration(days: 365)),
          initialDate: value ?? now,
        );
        if (d != null) onPicked(d);
      },
      child: Text(
        value == null ? label : '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}',
      ),
    );
  }

// --- Time Button with 24h/12h + minute rounding ---
  Widget timeBtn({
    required BuildContext context,                 // caller context
    required String label,                         // button label when no time
    required TimeOfDay? value,                     // current time value
    required ValueChanged<TimeOfDay> onPicked,     // callback with picked time
    bool use24h = true,                            // toggle 24h vs 12h
    int minuteStep = 5,                            // round minutes to step
  }) {
    return OutlinedButton.icon(
      // pick time via system dialog
      onPressed: () async {
        // showTimePicker honors MediaQuery(alwaysUse24HourFormat)
        final t = await showTimePicker(
          context: context,
          initialTime: value ?? const TimeOfDay(hour: 9, minute: 0),
          helpText: label, // header title
          builder: (ctx, child) => MediaQuery(
            // force 24h/12h depending on flag
            data: MediaQuery.of(ctx!).copyWith(alwaysUse24HourFormat: use24h),
            child: child!,
          ),
        );

        if (t != null) {
          // round minutes to the nearest step (e.g., 5, 10, 15)
          final rounded = _roundTimeOfDay(t, minuteStep);

          // emit normalized value to parent
          onPicked(rounded);
        }
      },
      icon: const Icon(Icons.access_time), // small visual hint
      label: Text(
        value == null
            ? label
            : _formatTime(context, value, use24h: use24h), // formatted display
      ),
    );
  }

// --- Round minutes to nearest step (handles overflow to next hour) ---
  TimeOfDay _roundTimeOfDay(TimeOfDay t, int step) {
    final totalMinutes = t.hour * 60 + t.minute;
    final roundedMinutes = (totalMinutes / step).round() * step;

    final newHour = (roundedMinutes ~/ 60) % 24;         // wrap 24h
    final newMinute = roundedMinutes % 60;

    return TimeOfDay(hour: newHour, minute: newMinute);
  }

// --- Format using MaterialLocalizations (12h) OR manual (24h) ---
  String _formatTime(BuildContext context, TimeOfDay t, {bool use24h = true}) {
    if (use24h) {
      // 24h: 09:05
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } else {
      // 12h with AM/PM according to locale
      final loc = MaterialLocalizations.of(context);
      return loc.formatTimeOfDay(t, alwaysUse24HourFormat: false);
    }
  }

}
