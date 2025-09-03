// lib/Components/place_search_field.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

import '../Service/google_places_service.dart';
import '../Service/address_parts.dart';

class PlaceSearchField extends StatefulWidget {
  final GooglePlacesService service;
  final TextEditingController controller;
  final String? hintText;
  final void Function(AddressParts parts) onPlaceResolved;

  const PlaceSearchField({
    super.key,
    required this.service,
    required this.controller,
    required this.onPlaceResolved,
    this.hintText,
  });

  @override
  State<PlaceSearchField> createState() => _PlaceSearchFieldState();
}

class _PlaceSearchFieldState extends State<PlaceSearchField> {
  final _debounce = const Duration(milliseconds: 250);
  Timer? _timer;
  List<AutocompletePrediction> _predictions = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _timer?.cancel();
    super.dispose();
  }

  void _onChanged() {
    _timer?.cancel();
    _timer = Timer(_debounce, () async {
      final txt = widget.controller.text.trim();
      if (txt.isEmpty) {
        if (mounted) setState(() => _predictions = []);
        return;
      }
      final list = await widget.service.autocomplete(txt);
      if (mounted) setState(() => _predictions = list);
    });
  }

  Future<void> _usePrediction(AutocompletePrediction p) async {
    if (p.placeId == null) return;
    final parts = await widget.service.fetchPartsFromPlaceId(p.placeId!);
    if (parts == null) return;

    // Update text field
    widget.controller.text = parts.formattedAddress;

    // Clear predictions + hide keyboard
    if (mounted) {
      setState(() => _predictions = []);
      FocusScope.of(context).unfocus();  // 👈 closes keyboard & suggestion list
    }

    // Notify parent (map, provider, etc.)
    widget.onPlaceResolved(parts);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Search address',
            hintStyle: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
            suffixIcon: _predictions.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                widget.controller.clear();
                setState(() => _predictions = []);
              },
            )
                : null,
          ),
        ),
        if (_predictions.isNotEmpty)
          Card(
            margin: const EdgeInsets.only(top: 6.0),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _predictions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final p = _predictions[i];
                return ListTile(
                  dense: true,
                  title: Text(p.description ?? '', style: theme.textTheme.bodyMedium),
                  onTap: () => _usePrediction(p),
                );
              },
            ),
          ),
      ],
    );
  }
}
