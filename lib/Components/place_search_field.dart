// lib/Components/place_search_field.dart
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../Service/address_parts.dart';
import '../Service/google_places_service.dart';

class PlaceSearchField extends StatefulWidget {
  final GooglePlacesService service;
  final TextEditingController controller;
  final String? hintText;
  final FocusNode? focusNode;   // ✅ new

  final void Function(AddressParts parts) onPlaceResolved;

  const PlaceSearchField({
    super.key,
    required this.service,
    required this.controller,
    required this.onPlaceResolved,
    this.hintText, this.focusNode,
  });

  @override
  State<PlaceSearchField> createState() => _PlaceSearchFieldState();
}

class _PlaceSearchFieldState extends State<PlaceSearchField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GooglePlaceAutoCompleteTextField(
      focusNode: widget.focusNode,   // ✅ wire it here

      textEditingController: widget.controller,
      googleAPIKey: widget.service.apiKey,   // pass key here
      inputDecoration: InputDecoration(
        hintText: widget.hintText ?? 'Search your location',
        hintStyle: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      debounceTime: 350,
      // Limit countries if needed: e.g. ["tn","fr"]
      // countries: const ["tn"],

      // We need lat/lng from prediction
      isLatLngRequired: true,

      // When user taps an item in the list
      itemClick: (Prediction prediction) async {
        // Set text
        widget.controller.text = prediction.description ?? "";
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length),
        );

        // Resolve to AddressParts (reverse geocode to get city/state/postal)
        final parts = await widget.service.predictionToAddressParts(prediction);
        if (parts != null) {
          widget.onPlaceResolved(parts);
        }

        // Close the predictions list by unfocusing
        FocusScope.of(context).unfocus();
      },

      // Called when details (lat,lng) are computed
      getPlaceDetailWithLatLng: (Prediction prediction) async {
        // Optional: also resolve here in case you want
        final parts = await widget.service.predictionToAddressParts(prediction);
        if (parts != null) {
          widget.onPlaceResolved(parts);
        }
        // Close predictions list
        FocusScope.of(context).unfocus();
      },

      // Custom item builder (optional)
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  prediction.description ?? '',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            ],
          ),
        );
      },

      // Separator line
      seperatedBuilder: const Divider(height: 1),
      // Add a clear button
      isCrossBtnShown: true,
      // match your styles
      containerHorizontalPadding: 0,
    );
  }
}
