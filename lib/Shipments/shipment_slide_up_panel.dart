// shipment_slide_up_panel.dart
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../Models/shipment_model.dart';
import '../Models/transport_request_model.dart';
import '../Models/quick_transport_request_model.dart';
import '../ViewModels/shipment_provider.dart';
import 'live_shipment_map.dart';

class ShipmentSlideUpPanel extends StatefulWidget {
  final Shipment shipment;
  final String serviceType;
  final String originAddress;
  final String destinationAddress;

  const ShipmentSlideUpPanel({
    super.key,
    required this.shipment,
    required this.serviceType,
    required this.originAddress,
    required this.destinationAddress,
  });

  @override
  State<ShipmentSlideUpPanel> createState() => _ShipmentSlideUpPanelState();
}

class _ShipmentSlideUpPanelState extends State<ShipmentSlideUpPanel> {
  @override
  void dispose() {
    context.read<ShipmentProvider>().stopTracking();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final s = widget.shipment;
    final theme = Theme.of(context);

    final TransportRequestModel? tReq = s.transportRequest;
    final QuickTransportRequestModel? qReq = s.quickTransportRequest;

    DateTime? getPickUpDate() => tReq?.pickUpDate ?? qReq?.pickUpDate;
    DateTime? getDeliveryDate() => tReq?.deliveryDate ?? qReq?.deliveryDate;
    // get JWT from shared preferences

    return SafeArea(
      child: DraggableScrollableSheet(
        minChildSize: 0.2,
        initialChildSize: 0.5,
        maxChildSize: 1.0,
        expand: true,
        builder: (context, controller) {
          return ListView(
            controller: controller,
            padding: const EdgeInsets.symmetric(horizontal: 6.7),
            children: <Widget>[
              // --- Route ---
              //live tracking
              GestureDetector(
                onTap: () => {
                  context.read<ShipmentProvider>().startTracking(
                        shipmentId: widget.shipment.idShipment,
                      ),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveShipmentMap(
                            shipmentId: widget.shipment.idShipment),
                      ))
                },
                child: _surfaceCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(
                          icon: Icons.route_rounded, title: 'Route'),
                      const SizedBox(height: 6),
                      _LocationTile(
                        icon: Icons.location_on_rounded,
                        title: widget.originAddress,
                        subtitle: 'Origin Address',
                        dotColor: theme.primaryColor,
                      ),
                      const SizedBox(height: 8),
                      _DashedDivider(
                          color: theme.dividerColor.withOpacity(0.4)),
                      const SizedBox(height: 8),
                      _LocationTile(
                        icon: Icons.flag_rounded,
                        title: widget.destinationAddress,
                        subtitle: 'Destination Address',
                        dotColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // --- Shipment Details ---
              _surfaceCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeader(
                        icon: Icons.info_outline, title: 'Shipment Details'),
                    const SizedBox(height: 12),
                    _kvRow(context, 'Service Type', widget.serviceType),
                    _kvRow(context, 'Status', s.status.name),
                    _kvRow(
                        context,
                        'Pick-up Date',
                        getPickUpDate() != null
                            ? DateFormat.yMMMd().format(getPickUpDate()!)
                            : '—'),
                    _kvRow(
                        context,
                        'Delivery Date',
                        getDeliveryDate() != null
                            ? DateFormat.yMMMd().format(getDeliveryDate()!)
                            : '—'),
                    _kvRow(context, 'Created At',
                        DateFormat.yMMMd().add_jm().format(s.createdAt)),
                    _kvRow(
                        context,
                        'Last Update',
                        s.updatedAt != null
                            ? DateFormat.yMMMd().add_jm().format(s.updatedAt!)
                            : '—'),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // --- Driver Info ---
              _surfaceCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeader(
                        icon: Icons.local_shipping, title: 'Driver'),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        child: Icon(Icons.person,
                            color: theme.primaryColor, size: 28),
                      ),
                      title: Text(
                        s.driver.user?.name ?? '',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text("License: ${s.driver.licenseNumber ?? 'N/A'}",
                              style: theme.textTheme.bodyLarge),
                          if (s.driver.user?.email != null)
                            Text("Email: ${s.driver.user!.email!}",
                                style: theme.textTheme.bodyLarge),
                          if (s.driver.user?.phoneNumber != null)
                            Text("Phone: ${s.driver.user!.phoneNumber!}",
                                style: theme.textTheme.bodyLarge),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Chip(
                                label: Text(s.driver.vehicleType ?? "—"),
                                avatar:
                                    const Icon(Icons.local_shipping, size: 18),
                              ),
                              const SizedBox(height: 6),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // --- User Info ---
              _surfaceCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeader(
                        icon: Icons.account_circle, title: 'User'),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(Icons.person, color: Colors.blue),
                      ),
                      title: Text(
                        s.user.name ?? '',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(s.user.email ?? '—'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // --- Merchandise ---
              if (tReq?.merchandise != null)
                _surfaceCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(
                          icon: Icons.inventory_2, title: 'Merchandise'),
                      const SizedBox(height: 12),

                      // Freight vs Household
                      if (widget.serviceType == "FREIGHT_TRANSPORTATION") ...[
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            if ((tReq!.merchandise
                                        ?.standard20FeetContainersNumber ??
                                    0) >
                                0)
                              _iconCounter(
                                  "20ft Containers",
                                  tReq.merchandise!
                                      .standard20FeetContainersNumber!),
                            if ((tReq.merchandise
                                        ?.standard40FeetContainersNumber ??
                                    0) >
                                0)
                              _iconCounter(
                                  "40ft Containers",
                                  tReq.merchandise!
                                      .standard40FeetContainersNumber!),
                            if ((tReq.merchandise
                                        ?.highCube40FeetContainersNumber ??
                                    0) >
                                0)
                              _iconCounter(
                                  "High Cube 40ft",
                                  tReq.merchandise!
                                      .highCube40FeetContainersNumber!),
                            if ((tReq.merchandise?.pallets.length ?? 0) > 0)
                              _iconCounter(
                                  "Pallets", tReq.merchandise!.pallets.length),
                            if ((tReq.merchandise?.boxes.length ?? 0) > 0)
                              _iconCounter(
                                  "Boxes", tReq.merchandise!.boxes.length),
                          ],
                        ),
                      ] else ...[
                        // Quick Items Chips
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            if ((tReq!.merchandise?.airConditioners ?? 0) > 0)
                              _chip("Air Conditioners",
                                  tReq.merchandise!.airConditioners!),
                            if ((tReq.merchandise?.deskChairs ?? 0) > 0)
                              _chip(
                                  "Desk Chairs", tReq.merchandise!.deskChairs!),
                            if ((tReq.merchandise?.chairs ?? 0) > 0)
                              _chip("Chairs", tReq.merchandise!.chairs!),
                            if ((tReq.merchandise?.washingMachines ?? 0) > 0)
                              _chip("Washing Machines",
                                  tReq.merchandise!.washingMachines!),
                            if ((tReq.merchandise?.dishWashingMachines ?? 0) >
                                0)
                              _chip("Dish Washers",
                                  tReq.merchandise!.dishWashingMachines!),
                            if ((tReq.merchandise?.refrigerators ?? 0) > 0)
                              _chip("Refrigerators",
                                  tReq.merchandise!.refrigerators!),
                            if ((tReq.merchandise?.televisions ?? 0) > 0)
                              _chip("Televisions",
                                  tReq.merchandise!.televisions!),
                            if ((tReq.merchandise?.microwaves ?? 0) > 0)
                              _chip(
                                  "Microwaves", tReq.merchandise!.microwaves!),
                            if ((tReq.merchandise?.ovens ?? 0) > 0)
                              _chip("Ovens", tReq.merchandise!.ovens!),
                            if ((tReq.merchandise?.singlePlaceBed ?? 0) > 0)
                              _chip("Single Beds",
                                  tReq.merchandise!.singlePlaceBed!),
                            if ((tReq.merchandise?.doublePlaceBed ?? 0) > 0)
                              _chip("Double Beds",
                                  tReq.merchandise!.doublePlaceBed!),
                            if ((tReq.merchandise?.masterBedrooms ?? 0) > 0)
                              _chip("Master Bedrooms",
                                  tReq.merchandise!.masterBedrooms!),
                            if ((tReq.merchandise?.dressingTables ?? 0) > 0)
                              _chip("Dressing Tables",
                                  tReq.merchandise!.dressingTables!),
                          ],
                        ),
                        const Divider(height: 24),
                        // Table of merchandise items
                        _tableHeader(context),
                        ...?tReq.merchandise?.desks.map((d) => _tableRow(
                            context,
                            "Desk",
                            "1",
                            "${d.length}×${d.width}×${d.height}",
                            "${d.weight}")),
                        ...?tReq.merchandise?.boxes.map((b) => _tableRow(
                            context,
                            "Box",
                            "1",
                            "${b.length}×${b.width}×${b.height}",
                            "${b.weight}")),
                        ...?tReq.merchandise?.cardboards.map((cb) => _tableRow(
                            context,
                            "Cardboard",
                            "1",
                            "${cb.length}×${cb.width}×${cb.height}",
                            "${cb.weight}")),
                        ...?tReq.merchandise?.pallets.map((p) => _tableRow(
                            context,
                            "Pallet (${p.type})",
                            "1",
                            "${p.length}×${p.width}×${p.height}",
                            "${p.weight}")),
                        ...?tReq.merchandise?.sofas.map((s) => _tableRow(
                            context,
                            "Sofa",
                            "1",
                            "${s.length}×${s.width}×${s.height}",
                            "${s.weight}")),
                        ...?tReq.merchandise?.mattresses.map((m) => _tableRow(
                            context,
                            "Mattress",
                            "1",
                            "${m.length}×${m.width}",
                            "${m.weight}")),
                        ...?tReq.merchandise?.wardrobes.map((w) => _tableRow(
                            context,
                            "Wardrobe",
                            "1",
                            "${w.length}×${w.width}×${w.height}",
                            "${w.weight}")),
                        ...?tReq.merchandise?.cabinets.map((c) => _tableRow(
                            context,
                            "Cabinet",
                            "1",
                            "${c.length}×${c.width}×${c.height}",
                            "${c.weight}")),
                        ...?tReq.merchandise?.otherFurniture.map((f) =>
                            _tableRow(
                                context,
                                f.description ?? "Furniture",
                                "1",
                                "${f.length}×${f.width}×${f.height}",
                                "${f.weight}")),
                      ]
                    ],
                  ),
                ),
              const SizedBox(height: 10),

              // --- Payment ---
              if (tReq?.paymentMethod != null)
                _surfaceCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(
                          icon: Icons.payment, title: 'Payment'),
                      const SizedBox(height: 12),
                      _kvRow(context, 'Method', tReq?.paymentMethod ?? '—'),
                      _kvRow(
                          context, 'Condition', tReq?.paymentCondition ?? '—'),
                      _kvRow(context, 'Other Terms', tReq?.otherTerms ?? '—'),
                    ],
                  ),
                ),
              const SizedBox(height: 10),

              // --- Timeline ---
              if (s.timeline.isNotEmpty)
                _surfaceCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(
                          icon: Icons.timeline, title: 'Timeline'),
                      const SizedBox(height: 12),
                      Column(
                        children: s.timeline.map((t) {
                          return ListTile(
                            leading: Icon(Icons.check_circle,
                                color: theme.primaryColor),
                            title: Text(t.title ?? t.type.name),
                            subtitle: Text(t.message),
                            trailing: Text(
                              DateFormat.yMMMd().add_jm().format(t.dateTime),
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }

  // --- Helpers ---
  Widget _surfaceCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 8, left: 20, right: 20),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
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
            child: Text(k,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.hintColor.withOpacity(0.7),
                )),
          ),
          Expanded(
            flex: 7,
            child: Text(v,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
                textAlign: TextAlign.right),
          )
        ],
      ),
    );
  }

  Widget _iconCounter(String label, int count) {
    return Chip(
      avatar: const Icon(Icons.inventory_2, size: 20, color: Colors.blue),
      label: Text("$label ($count)"),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(color: Colors.grey.shade300),
    );
  }

  Widget _chip(String label, int count) {
    return Chip(
      avatar: Icon(_quickItemIcon(label), size: 20, color: Colors.blue),
      label: Text("$label ($count)"),
      backgroundColor: Colors.grey.shade50,
      side: BorderSide(color: Colors.grey.shade200),
    );
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

  Widget _tableRow(
      BuildContext context, String i, String q, String d, String w) {
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

  IconData _quickItemIcon(String label) {
    switch (label) {
      case "Air Conditioners":
        return Icons.ac_unit;
      case "Desk Chairs":
        return Icons.chair_alt;
      case "Chairs":
        return Icons.event_seat;
      case "Washing Machines":
        return Icons.local_laundry_service;
      case "Dish Washers":
        return Icons.kitchen;
      case "Refrigerators":
        return Icons.kitchen_outlined;
      case "Televisions":
        return Icons.tv;
      case "Microwaves":
        return Icons.microwave;
      case "Ovens":
        return Icons.local_fire_department;
      case "Single Beds":
        return Icons.bedroom_child_outlined;
      case "Double Beds":
        return Icons.bed;
      case "Master Bedrooms":
        return Icons.king_bed;
      case "Dressing Tables":
        return Icons.table_bar;
      default:
        return Icons.inventory_2;
    }
  }
}

// --- Reusable widgets (same as TrackDelivery) ---
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.primaryColorDark,
          ),
        ),
      ],
    );
  }
}

class _LocationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color dotColor;
  const _LocationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: dotColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor)),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 4.0;
        final dashHeight = 1.0;
        final dashCount = (constraints.maxWidth / (2 * dashWidth)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}
