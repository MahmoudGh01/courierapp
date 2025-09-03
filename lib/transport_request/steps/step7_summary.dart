import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Theme/colors.dart';
import '../../ViewModels/transport_request_provider.dart';
import '../../utils/constants.dart';

class Step7Summary extends StatelessWidget {
  final VoidCallback onSubmitSuccess;
  final VoidCallback onBack;
  const Step7Summary({
    super.key,
    required this.onSubmitSuccess,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    // -- read provider + theme
    final p     = context.watch<TransportRequestProvider>();
    final theme = Theme.of(context);

    // -- submit function (POST payload with Bearer token)
    Future<void> _submit() async {
      final payload = p.dto.toJson(); // build payload
      final prefs   = await SharedPreferences.getInstance();
      final token   = prefs.getString('token') ?? '';

      try {
        final res = await http.post(
          Uri.parse('${Constants.uri}transport-requests'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(payload),
        );

        if (res.statusCode == 200 || res.statusCode == 201) {
          onSubmitSuccess();
        } else {
          // try to extract error body text if any
          final err = res.body.isNotEmpty ? res.body : 'HTTP ${res.statusCode}';
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Submit failed: $err')),
          );
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
      }
    }

    // -- small chip UI for enum/value display
    Widget _pill(String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.primaryColor.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    // -- section container
    Widget _sectionCard({
      required String title,
      required Widget child,
    }) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // section title
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      );
    }

    // -- label/value line
    Widget _kv(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value.isEmpty ? '—' : value,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }

    // -- DataTable wrapped for horizontal scroll (avoid overflow)
    Widget _itemsTable() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Item')),
            DataColumn(label: Text('Dim (cm)')),
            DataColumn(label: Text('Weight (kg)')),
            DataColumn(label: Text('Fragile')),
          ],
          rows: [
            ...p.dto.items.asMap().entries.map((e) {
              final i  = e.key + 1;
              final it = e.value;
              return DataRow(
                cells: [
                  DataCell(Text('${it.category} #$i')),
                  DataCell(Text('${it.lengthCm} × ${it.widthCm} × ${it.heightCm}')),
                  DataCell(Text(it.weightKg.toStringAsFixed(2))),
                  DataCell(Text(it.fragile ? 'Yes' : 'No')),
                ],
              );
            }),
          ],
        ),
      );
    }

    // -- readable date/time lines
    String _fmtDate(DateTime? d) =>
        d == null ? '—' : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    String _fmtTime(String? t) => (t == null || t.isEmpty) ? '—' : t;

    return Scaffold(
      backgroundColor: kWhiteColor, // ✅ light background for readability
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ---- Title ----
                      Text(
                        'Step 7 of 8 — Summary',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ---- Service Type ----
                      _sectionCard(
                        title: 'Service Type',
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _pill(p.dto.serviceType.name),
                          ],
                        ),
                      ),

                      // ---- Locations ----
                      _sectionCard(
                        title: 'Locations',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Origin', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            _kv('Address', p.dto.originAddress),
                            _kv('City / State', '${p.dto.originCity} / ${p.dto.originState}'),
                            _kv('Postal Code', p.dto.originPostalCode),
                            _kv('Coordinates', '${p.dto.originLatitude}, ${p.dto.originLongitude}'),
                            const Divider(height: 16),
                            Text('Destination', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            _kv('Address', p.dto.destinationAddress),
                            _kv('City / State', '${p.dto.destinationCity} / ${p.dto.destinationState}'),
                            _kv('Postal Code', p.dto.destinationPostalCode),
                            _kv('Coordinates', '${p.dto.destinationLatitude}, ${p.dto.destinationLongitude}'),
                          ],
                        ),
                      ),

                      // ---- Scheduling ----
                      _sectionCard(
                        title: 'Scheduling',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _kv('Pick-up Date', _fmtDate(p.dto.pickUpDate)),
                            _kv('Pick-up Time', _fmtTime(p.dto.pickUpTime)),
                            _kv('Delivery Date', _fmtDate(p.dto.deliveryDate)),
                            _kv('Delivery Time', _fmtTime(p.dto.deliveryTime)),
                            const SizedBox(height: 8),
                            Wrap(
                              runSpacing: 6,
                              spacing: 6,
                              children: [
                                _pill('Pick-up Flex: ${p.dto.pickUpFlexibilityInDays ?? 0}d'),
                                _pill('Pick-up Flex: ${p.dto.pickUpFlexibilityInHours ?? 0}h'),
                                _pill('Delivery Flex: ${p.dto.deliveryFlexibilityInDays ?? 0}d'),
                                _pill('Delivery Flex: ${p.dto.deliveryFlexibilityInHours ?? 0}h'),
                              ],
                            ),
                            const Divider(height: 18),
                            Text('Floors & Elevators', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            _kv('Departure Floor', '${p.dto.departureFloor ?? 0}'),
                            _kv('Arrival Floor', '${p.dto.arrivalFloor ?? 0}'),
                            _kv('Elevator at Departure', (p.dto.isElevatorAvailableForDeparture ?? false) ? 'Yes' : 'No'),
                            _kv('Elevator at Arrival', (p.dto.isElevatorAvailableForArrival ?? false) ? 'Yes' : 'No'),
                            const Divider(height: 18),
                            Text('Dismantling', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            _kv('Required', (p.dto.isDismantlingRequired ?? false) ? 'Yes' : 'No'),
                            _kv('Type', p.dto.dismantlingType?.name ?? '—'),
                            _kv('Pieces', '${p.dto.numberOfPiecesToDesmantle ?? 0}'),
                          ],
                        ),
                      ),

                      // ---- Merchandise ----
                      _sectionCard(
                        title: 'Merchandise',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _kv('Type', p.dto.merchandiseType ?? 'General Goods'),
                            _kv('Total Weight', '${p.dto.totalWeightKg.toStringAsFixed(2)} kg'),
                            _kv('Total Volume', '${p.dto.totalVolumeM3.toStringAsFixed(3)} m³'),
                            const SizedBox(height: 8),
                            Text('Items', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            _itemsTable(),
                          ],
                        ),
                      ),

                      // ---- Vehicle ----
                      _sectionCard(
                        title: 'Vehicle',
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _pill('Type: ${p.dto.vehicleType.name}'),
                            _pill('Capacity: ${p.dto.loadingCapacity.name}'),
                            _pill('Access: ${p.dto.accessType.name}'),
                            if (p.dto.maxWidth != null) _pill('Max W: ${p.dto.maxWidth} m'),
                            if (p.dto.maxHeight != null) _pill('Max H: ${p.dto.maxHeight} m'),
                          ],
                        ),
                      ),

                      // ---- Payment ----
                      _sectionCard(
                        title: 'Payment',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _pill('Method: ${p.dto.paymentMethod.name}'),
                                _pill('Condition: ${p.dto.paymentCondition.name}'),
                              ],
                            ),
                            if ((p.dto.otherTerms ?? '').isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _kv('Other Terms', p.dto.otherTerms ?? ''),
                            ],
                          ],
                        ),
                      ),

                      // ---- Additional ----
                      _sectionCard(
                        title: 'Additional Information',
                        child: _kv('Instructions', p.dto.additionalInstructions ?? '—'),
                      ),

                      const Spacer(),

                      // ---- Footer (Back / Submit) ----
                      Row(
                        children: [
                          OutlinedButton(onPressed: onBack, child: const Text('Back')),
                          const Spacer(),
                          ElevatedButton(onPressed: _submit, child: const Text('Submit')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
