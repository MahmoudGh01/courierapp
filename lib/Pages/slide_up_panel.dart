import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

import '../Models/transport_request_model.dart';
class SlideUpPanel extends StatefulWidget {
  final TransportRequestModel item;
  const SlideUpPanel({super.key, required this.item});

  @override
  State<SlideUpPanel> createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<SlideUpPanel> {
  @override
  Widget build(BuildContext context) {
    final m     = widget.item;
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      minChildSize: 0.2,
      initialChildSize: 0.5,
      maxChildSize: 1.0,
      expand: true,
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.symmetric(horizontal: 6.7),
          children: <Widget>[
            // ---- Addresses ----
            _sectionCard(
              context,
              title: 'Addresses',
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.redAccent),
                    title: Text(m.originCity, style: theme.textTheme.titleLarge),
                    subtitle: Text(m.originAddress),
                  ),
                  ListTile(
                    leading: Icon(Icons.navigation, color: Colors.blueAccent),
                    title: Text(m.destinationCity, style: theme.textTheme.titleLarge),
                    subtitle: Text(m.destinationAddress),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ---- Details ----
            _sectionCard(
              context,
              title: 'Details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kvRow(context, 'Service Type', m.serviceType),
                  _kvRow(context, 'Status', m.status),
                  _kvRow(context, 'Pick-up Date', m.pickUpDate?.toIso8601String() ?? '—'),
                  _kvRow(context, 'Delivery Date', m.deliveryDate?.toIso8601String() ?? '—'),
                  _kvRow(context, 'Pick-up Time', m.pickUpTime ?? '—'),
                  _kvRow(context, 'Delivery Time', m.deliveryTime ?? '—'),
                  _kvRow(context, 'Vehicle Type', m.vehicleType ?? '—'),
                  _kvRow(context, 'Access Type', m.accessType ?? '—'),
                  _kvRow(context, 'Loading Capacity', m.loadingCapacity ?? '—'),
                  _kvRow(context, 'Max Width', m.maxWidth?.toString() ?? '—'),
                  _kvRow(context, 'Max Height', m.maxHeight?.toString() ?? '—'),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ---- Merchandise ----
            // ---- Merchandise ----
            _sectionCard(
              context,
              title: 'Merchandise',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kvRow(context, 'Merchandise Type', m.merchandise?.merchandiseType ?? '—'),
                  _kvRow(context, 'Loading Type',      m.merchandise?.loadingType ?? '—'),
                  _kvRow(context, 'Total Weight',      '${m.merchandise?.totalWeight ?? 0} kg'),
                  _kvRow(context, 'Total Volume',      '${m.merchandise?.totalVolume ?? 0} m³'),
                  const SizedBox(height: 6),

                  _kvRow(context, 'Special handling', (m.merchandise?.isSpecialHandlingRequired ?? false) ? 'Yes' : 'No'),
                  _kvRow(context, 'Additional protection', (m.merchandise?.isAdditionalProtectionRequired ?? false) ? 'Yes' : 'No'),
                  _kvRow(context, 'Tail lift required', (m.merchandise?.isVehicleWithTailElevatorRequired ?? false) ? 'Yes' : 'No'),

                  const Divider(height: 24),
                  Text('Items', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _tableHeader(context),

                  // 🔽 Render desks
                  ...m.merchandise?.desks.map((d) => _tableRow(
                      context,
                      "Desk",
                      "1",
                      "${d.length}×${d.width}×${d.height}",
                      "${d.weight}"
                  )) ?? [],

                  // 🔽 Render cabinets
                  ...m.merchandise?.cabinets.map((c) => _tableRow(
                      context,
                      "Cabinet",
                      "1",
                      "${c.length}×${c.width}×${c.height}",
                      "${c.weight}"
                  )) ?? [],

                  // 🔽 Render sofas
                  ...m.merchandise?.sofas.map((s) => _tableRow(
                      context,
                      "Sofa",
                      "1",
                      "${s.length}×${s.width}×${s.height}",
                      "${s.weight}"
                  )) ?? [],

                  // 🔽 Render mattresses
                  ...m.merchandise?.mattresses.map((mt) => _tableRow(
                      context,
                      "Mattress",
                      "1",
                      "${mt.length}×${mt.width}",
                      "${mt.weight}"
                  )) ?? [],

                  // 🔽 Render cardboards
                  ...m.merchandise?.cardboards.map((cb) => _tableRow(
                      context,
                      "Cardboard (fragile: ${cb.isFragile ? "Yes" : "No"})",
                      "1",
                      "${cb.length}×${cb.width}×${cb.height}",
                      "${cb.weight}"
                  )) ?? [],

                  // 🔽 Render other furniture
                  ...m.merchandise?.otherFurniture.map((f) => _tableRow(
                      context,
                      f.description ?? "Furniture",
                      "1",
                      "${f.length}×${f.width}×${f.height}",
                      "${f.weight}"
                  )) ?? [],

                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total Weight: ${m.merchandise?.totalWeight ?? 0} kg',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ---- Payment ----
            _sectionCard(
              context,
              title: 'Payment',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kvRow(context, 'Method', m.paymentMethod.toString() ?? '—'),
                  _kvRow(context, 'Condition', m.paymentCondition ?? '—'),
                  _kvRow(context, 'Other Terms', m.otherTerms ?? '—'),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ---- Additional ----
            _sectionCard(
              context,
              title: 'Additional Instructions',
              child: Text(m.additionalInstructions ?? 'None'),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  // ----------------- UI HELPERS -----------------
  Widget _sectionCard(BuildContext context, {required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [boxShadow],
        color: kWhiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(35.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium?.copyWith(
            color: theme.primaryColorDark,
            fontWeight: FontWeight.w700,
          )),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _kvRow(BuildContext context, String k, String v) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(k, style: theme.textTheme.titleMedium?.copyWith(
              color: theme.hintColor.withOpacity(0.7),
            )),
          ),
          Expanded(
            flex: 7,
            child: Text(v, style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600, height: 1.4,
            ), textAlign: TextAlign.right),
          )
        ],
      ),
    );
  }
}


Widget _tableHeader(BuildContext context) {
  final theme = Theme.of(context);
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    decoration: BoxDecoration(
      color: theme.cardColor.withOpacity(0.25),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        _thCell(context, 'Item', flex: 3),
        _thCell(context, 'Quantity', flex: 2),
        _thCell(context, 'Dimensions (cm)', flex: 4),
        _thCell(context, 'Weight (kg)', flex: 3),
      ],
    ),
  );
}

Widget _tableRow(BuildContext context, String i, String q, String d, String w) {
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    child: Row(
      children: [
        Expanded(flex: 3, child: Text(i, style: theme.textTheme.bodyMedium)),
        Expanded(flex: 2, child: Text(q, style: theme.textTheme.bodyMedium)),
        Expanded(flex: 4, child: Text(d, style: theme.textTheme.bodyMedium)),
        Expanded(flex: 3, child: Text(w, style: theme.textTheme.bodyMedium)),
      ],
    ),
  );
}

Widget _thCell(BuildContext context, String label, {int flex = 1}) {
  final theme = Theme.of(context);
  return Expanded(
    flex: flex,
    child: Text(
      label,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.primaryColorDark,
      ),
    ),
  );
}

