import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Models/enums.dart';
import '../Models/transport_request_model.dart';
import '../transport_request/Offers/offers_list.dart';

class SlideUpPanel extends StatefulWidget {
  final TransportRequestModel item;
  const SlideUpPanel({super.key, required this.item});

  @override
  State<SlideUpPanel> createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<SlideUpPanel> {
  @override
  Widget build(BuildContext context) {
    final m = widget.item;
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
            _surfaceCard(
              context, // action card
              child: ListTile(
                // list tile
                title: Text(
                  // title
                  'View Offers',
                  style: theme.textTheme.titleMedium?.copyWith(
                    // style
                    fontWeight: FontWeight.w700, // bold
                  ),
                ),
                trailing: FadedScaleAnimation(
                  // animated cta
                  child: CircleAvatar(
                    // round button
                    radius: 24, // size
                    backgroundColor: kMainColor, // accent
                    child: const Icon(Icons.arrow_forward_ios,
                        size: 18, color: Colors.white), // icon
                  ),
                ),
                onTap: () {
                  // navigate
                  Navigator.push(
                    // push offers
                    context,
                    MaterialPageRoute(
                      builder: (_) => OffersListPage(
                          requestId: widget.item.idTransportRequest), // pass id
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10), // gap
            // ---- Addresses ----
            _surfaceCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    icon: Icons.route_rounded,
                    title: 'Route',
                  ),
                  const SizedBox(height: 6),
                  _LocationTile(
                    icon: Icons.location_on_rounded,
                    title: m.originAddress ?? '-',
                    subtitle: 'Origin Address',
                    dotColor: theme.primaryColor,
                  ),
                  const SizedBox(height: 8),
                  _DashedDivider(color: theme.dividerColor.withOpacity(0.4)),
                  const SizedBox(height: 8),
                  _LocationTile(
                    icon: Icons.flag_rounded,
                    title: m.destinationAddress ?? '-',
                    subtitle: 'Destination Address',
                    dotColor: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

// ---- Details ----
// ---- Details ----
            _surfaceCard(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(icon: Icons.info_outline, title: 'Details'),
                  const SizedBox(height: 12),
                  _kvRow(context, 'Service Type', serviceTypeLabel(m.serviceType)),
                  _kvRow(context, 'Status', m.status ?? '—'),
                  _kvRow(context, 'Pick-up Date',
                      m.pickUpDate != null ? DateFormat.yMMMd().format(m.pickUpDate!) : '—'),
                  _kvRow(context, 'Delivery Date',
                      m.deliveryDate != null ? DateFormat.yMMMd().format(m.deliveryDate!) : '—'),
                  _kvRow(context, 'Pick-up Time', m.pickUpTime ?? '—'),
                  _kvRow(context, 'Delivery Time', m.deliveryTime ?? '—'),
                  _kvRow(context, 'Vehicle Type', vehicleTypeLabel(m.vehicleType)),
                  _kvRow(context, 'Access Type', accessTypeLabel(m.accessType)),
                  _kvRow(context, 'Loading Capacity', LoadingCapacityTypeLabel(m.loadingCapacity) ),
                  _kvRow(context, 'Max Width', m.maxWidth?.toString() ?? '—'),
                  _kvRow(context, 'Max Height', m.maxHeight?.toString() ?? '—'),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ---- Merchandise ----
            _sectionCard(
              context,
              title: 'Merchandise',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kvRow(context, 'Merchandise Type',
                      MerchandiseTypeLabel(m.merchandise?.merchandiseType)),
                  _kvRow(context, 'Loading Type', m.merchandise?.loadingType ?? '—'),
                  _kvRow(context, 'Total Weight',
                      '${m.merchandise?.totalWeight ?? 0} kg'),
                  _kvRow(context, 'Total Volume',
                      '${m.merchandise?.totalVolume ?? 0} m³'),
                  const SizedBox(height: 6),

                  _kvRow(
                      context,
                      'Special handling',
                      (m.merchandise?.isSpecialHandlingRequired ?? false) ? 'Yes' : 'No'),
                  _kvRow(
                      context,
                      'Additional protection',
                      (m.merchandise?.isAdditionalProtectionRequired ?? false) ? 'Yes' : 'No'),
                  _kvRow(
                      context,
                      'Tail lift required',
                      (m.merchandise?.isVehicleWithTailElevatorRequired ?? false) ? 'Yes' : 'No'),

                  const Divider(height: 24),

                  if (m.serviceType == ServiceType.FREIGHT_TRANSPORTATION.name) ...[
                    // ---------- FREIGHT VIEW ----------
                    Text("Freight Items",
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if ((m.merchandise?.standard20FeetContainersNumber ?? 0) > 0)
                          _iconCounter("20ft Containers", m.merchandise!.standard20FeetContainersNumber!),
                        if ((m.merchandise?.standard40FeetContainersNumber ?? 0) > 0)
                          _iconCounter("40ft Containers", m.merchandise!.standard40FeetContainersNumber!),
                        if ((m.merchandise?.highCube40FeetContainersNumber ?? 0) > 0)
                          _iconCounter("High Cube 40ft", m.merchandise!.highCube40FeetContainersNumber!),
                        if ((m.merchandise?.pallets.length ?? 0) > 0)
                          _iconCounter("Pallets", m.merchandise!.pallets.length),
                        if ((m.merchandise?.boxes.length ?? 0) > 0)
                          _iconCounter("Boxes", m.merchandise!.boxes.length),

                      ],
                    ),
                  ] else ...[
                    // ---------- HOUSEHOLD VIEW ----------
                    Text('Items',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _tableHeader(context),

                    ...?m.merchandise?.desks.map((d) => _tableRow(
                      context,
                      "Desk",
                      "1",
                      "${d.length}×${d.width}×${d.height}",
                      "${d.weight}",
                    )),
                    ...?m.merchandise?.boxes.map((b) => _tableRow(
                      context,
                      "Box",
                      "1",
                      "${b.length}×${b.width}×${b.height}",
                      "${b.weight}",
                    )),
                    ...?m.merchandise?.cardboards.map((cb) => _tableRow(
                      context,
                      "Cardboard (fragile: ${cb.isFragile ? "Yes" : "No"})",
                      "1",
                      "${cb.length}×${cb.width}×${cb.height}",
                      "${cb.weight}",
                    )),
                    ...?m.merchandise?.pallets.map((p) => _tableRow(
                      context,
                      "Pallet (${p.type})",
                      "1",
                      "${p.length}×${p.width}×${p.height}",
                      "${p.weight}",
                    )),
                    ...?m.merchandise?.mattresses.map((mt) => _tableRow(
                      context,
                      "Mattress",
                      "1",
                      "${mt.length}×${mt.width}",
                      "${mt.weight}",
                    )),
                    ...?m.merchandise?.sofas.map((s) => _tableRow(
                      context,
                      "Sofa",
                      "1",
                      "${s.length}×${s.width}×${s.height}",
                      "${s.weight}",
                    )),
                    ...?m.merchandise?.wardrobes.map((w) => _tableRow(
                      context,
                      "Wardrobe",
                      "1",
                      "${w.length}×${w.width}×${w.height}",
                      "${w.weight}",
                    )),
                    ...?m.merchandise?.cabinets.map((c) => _tableRow(
                      context,
                      "Cabinet",
                      "1",
                      "${c.length}×${c.width}×${c.height}",
                      "${c.weight}",
                    )),
                    ...?m.merchandise?.otherFurniture.map((f) => _tableRow(
                      context,
                      f.description ?? "Furniture",
                      "1",
                      "${f.length}×${f.width}×${f.height}",
                      "${f.weight}",
                    )),

                    const Divider(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Total Weight: ${m.merchandise?.totalWeight ?? 0} kg',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),

                    // Quick Counters (icons)
                    if ((m.merchandise?.airConditioners ?? 0) > 0 ||
                        (m.merchandise?.deskChairs ?? 0) > 0 ||
                        (m.merchandise?.chairs ?? 0) > 0 ||
                        (m.merchandise?.washingMachines ?? 0) > 0 ||
                        (m.merchandise?.dishWashingMachines ?? 0) > 0 ||
                        (m.merchandise?.refrigerators ?? 0) > 0 ||
                        (m.merchandise?.televisions ?? 0) > 0 ||
                        (m.merchandise?.microwaves ?? 0) > 0 ||
                        (m.merchandise?.ovens ?? 0) > 0 ||
                        (m.merchandise?.singlePlaceBed ?? 0) > 0 ||
                        (m.merchandise?.doublePlaceBed ?? 0) > 0 ||
                        (m.merchandise?.masterBedrooms ?? 0) > 0 ||
                        (m.merchandise?.dressingTables ?? 0) > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quick Items",
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              if ((m.merchandise?.airConditioners ?? 0) > 0)
                                _iconCounter("Air Conditioners", m.merchandise!.airConditioners!),
                              if ((m.merchandise?.deskChairs ?? 0) > 0)
                                _iconCounter("Desk Chairs", m.merchandise!.deskChairs!),
                              if ((m.merchandise?.chairs ?? 0) > 0)
                                _iconCounter("Chairs", m.merchandise!.chairs!),
                              if ((m.merchandise?.washingMachines ?? 0) > 0)
                                _iconCounter("Washing Machines", m.merchandise!.washingMachines!),
                              if ((m.merchandise?.dishWashingMachines ?? 0) > 0)
                                _iconCounter("Dish Washers", m.merchandise!.dishWashingMachines!),
                              if ((m.merchandise?.refrigerators ?? 0) > 0)
                                _iconCounter("Refrigerators", m.merchandise!.refrigerators!),
                              if ((m.merchandise?.televisions ?? 0) > 0)
                                _iconCounter("Televisions", m.merchandise!.televisions!),
                              if ((m.merchandise?.microwaves ?? 0) > 0)
                                _iconCounter("Microwaves", m.merchandise!.microwaves!),
                              if ((m.merchandise?.ovens ?? 0) > 0)
                                _iconCounter("Ovens", m.merchandise!.ovens!),
                              if ((m.merchandise?.singlePlaceBed ?? 0) > 0)
                                _iconCounter("Single Place Beds", m.merchandise!.singlePlaceBed!),
                              if ((m.merchandise?.doublePlaceBed ?? 0) > 0)
                                _iconCounter("Double Place Beds", m.merchandise!.doublePlaceBed!),
                              if ((m.merchandise?.masterBedrooms ?? 0) > 0)
                                _iconCounter("Master Bedrooms", m.merchandise!.masterBedrooms!),
                              if ((m.merchandise?.dressingTables ?? 0) > 0)
                                _iconCounter("Dressing Tables", m.merchandise!.dressingTables!),
                            ],
                          ),
                        ],
                      ),
                  ]
                ],
              ),
            ),


            const SizedBox(height: 10),

            // ---- Payment ----
// ---- Payment ----
            _sectionCard(
              context,
              title: 'Payment',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kvRow(context, 'Method', paymentMethodLabel(m.paymentMethod)),
                  _kvRow(context, 'Condition', paymentConditionLabel(m.paymentCondition)),
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

  Widget _sectionCard(BuildContext context,
      {required String title, required Widget child}) {
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
          Text(title,
              style: theme.textTheme.titleMedium?.copyWith(
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
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

String serviceTypeLabel(String? v) {
  switch (v) {
    case "RELOCATION":
      return "Relocation";
    case "FREIGHT_TRANSPORTATION":
      return "Freight Transportation";

    default:
      return "—";
  }
}

String vehicleTypeLabel(String? v) {
  switch (v) {
    case "LIGHT_TRUCK":
      return "Light Truck";
    case "MEDIUM_TRUCK":
      return "Medium Truck";
    case "SEMI_TRAILER":
      return "Semi Trailer";
    case "REFRIGERATED_TRUCK":
      return "Refrigerated Truck";
    case "TANK_TRUCK":
      return "Tank Truck";
    case "LIGHT_UTILITY_VEHICLE":
      return "Light Utility Vehicle";
    case "VAN":
      return "Van";
    case "ANY":
      return "Any Vehicle";
    case "OTHER":
      return "Other";
    default:
      return "—";
  }
}

String accessTypeLabel(String? v) {
  switch (v) {
    case "LARGE_VEHICLE_ACCESS":
      return "Large Vehicle Access";
    case "LIGHT_VEHICLE_ONLY":
      return "Light Vehicle Only";
    case "HEIGHT_WIDTH_RESTRICTIONS":
      return "Height/Width Restrictions";
    default:
      return "—";
  }
}

String paymentMethodLabel(String? v) {
  switch (v) {
    case "CASH_ON_DELIVERY":
      return "Cash on Delivery";
    case "BANK_TRANSFER":
      return "Bank Transfer";
    case "CREDIT_CARD_ON_DELIVERY":
      return "Credit Card on Delivery";
    case "CHECK":
      return "Check";
    default:
      return "—";
  }
}

String paymentConditionLabel(String? v) {
  switch (v) {
    case "PAYMENT_ON_RECEIPT":
      return "On Receipt";
    case "ADVANCE_PAYMENT":
      return "Advance";
    case "INSTALLMENT_PAYMENT":
      return "Installments";
    default:
      return "—";
  }
}
String LoadingCapacityTypeLabel(String? v) {
  switch (v) {
    case "LIGHT_DUTY":
      return "Light Duty";
    case "MEDIUM_DUTY":
      return "Medium Duty";
    case "HEAVY_DUTY":
      return "Heavy Duty";
    default:
      return "—";
  }
}

String MerchandiseTypeLabel(String? v) {
  switch (v) {
    case "REFRIGERATED_PRODUCTS":
      return "Refrigerated Products";
   case "GENERAL_GOODS":
      return "General Goods";
    case "HAZARDOUS_MATERIALS":
      return "Hazardous Materials";
    case "FRAGILE_GOODS":
      return "Fragile Goods";
    case "LIQUIDS":
      return "Liquids";
    case "GAS":
      return "Gas";
    case "CHEMICALS":
      return "Chemicals";
    case "FOOD":
      return "Food";
    case "OTHER":
      return "Other";
    default:
      return "—";
  }
}

Widget _iconCounter(String label, int count) {
  return Chip(
    avatar: Icon(counterIcon(label), size: 20 , color: Colors.blue,),
    label: Text("$label ($count)"),
    backgroundColor: Colors.grey.shade100,
    side: BorderSide(color: Colors.grey.shade300),
  );
}
IconData counterIcon(String label) {
  switch (label) {
    case "Air Conditioners": return Icons.ac_unit;
    case "Desk Chairs": return Icons.chair_alt;
    case "Chairs": return Icons.event_seat;
    case "Washing Machines": return Icons.local_laundry_service;
    case "Dish Washers": return Icons.kitchen;
    case "Refrigerators": return Icons.kitchen_outlined;
    case "Televisions": return Icons.tv;
    case "Microwaves": return Icons.microwave;
    case "Ovens": return Icons.local_fire_department;
    case "Single Place Beds": return Icons.bedroom_child_outlined;
    case "Double Place Beds": return Icons.bed;
    case "Master Bedrooms": return Icons.king_bed;
    case "Dressing Tables": return Icons.table_bar;
    default: return Icons.inventory_2; // fallback
  }
}
