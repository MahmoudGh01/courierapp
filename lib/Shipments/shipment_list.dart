import 'package:courier_app/Models/quick_transport_request_model.dart';
import 'package:courier_app/Models/transport_request_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/shipment_model.dart';
import '../ViewModels/shipment_provider.dart';
import 'shipment_detail.dart';
import '../Theme/style.dart';

class ShipmentListPage extends StatefulWidget {
  const ShipmentListPage({super.key});

  @override
  State<ShipmentListPage> createState() => _ShipmentListPageState();
}

class _ShipmentListPageState extends State<ShipmentListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShipmentProvider>().loadShipments();
  }

  Future<void> _refresh() async {
    await context.read<ShipmentProvider>().loadShipments();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShipmentProvider>();
    final shipments = provider.shipments;
    final theme = Theme.of(context);

    if (provider.loading) {
      return Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Shipments",
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          body: const Center(child: CircularProgressIndicator()));
    }

    if (shipments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text("No active shipments found",
              style: theme.textTheme.titleMedium),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Shipments",
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          displacement: 60,
          color: theme.primaryColor,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "${shipments.length} Active Shipments",
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: shipments.length,
                itemBuilder: (context, index) {
                  return _buildCard(context, theme, shipments[index]);
                },
              ),
              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, ThemeData theme, Shipment s) {
    // Explicit references
    final TransportRequestModel? transportReq = s.transportRequest;
    final QuickTransportRequestModel? quickReq = s.quickTransportRequest;

    // Helper accessors to unify data
    String getServiceType() =>
        transportReq?.serviceType ?? quickReq?.serviceType ?? "Shipment";

    String getOriginCity() =>
        transportReq?.originCity ?? quickReq?.originCity ?? "—";

    String getDestinationCity() =>
        transportReq?.destinationCity ?? quickReq?.destinationCity ?? "—";

    DateTime? getPickUpDate() =>
        transportReq?.pickUpDate ?? quickReq?.pickUpDate;

    DateTime? getDeliveryDate() =>
        transportReq?.deliveryDate ?? quickReq?.deliveryDate;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShipmentDetailPage(shipment: s),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsetsDirectional.only(end: 10),
        decoration: BoxDecoration(
          boxShadow: [boxShadow],
          borderRadius: BorderRadius.circular(10.0),
          color: theme.colorScheme.surface,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: <Widget>[
            // --- Header row ---
            Row(
              children: [
                Image.asset('images/home1.png', width: 60),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getServiceType(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat.yMMMd().add_jm().format(s.createdAt),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 36,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: s.status == ShipmentStatus.CONFIRMED
                          ? Colors.orange
                          : s.status == ShipmentStatus.DISPATCHED ||
                                  s.status == ShipmentStatus.IN_TRANSIT
                              ? Colors.blue
                              : s.status == ShipmentStatus.DELIVERED ||
                                      s.status == ShipmentStatus.COMPLETED
                                  ? Colors.green
                                  : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      s.status.name,
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: s.status == ShipmentStatus.CONFIRMED
                            ? Colors.orange
                            : s.status == ShipmentStatus.DISPATCHED ||
                                    s.status == ShipmentStatus.IN_TRANSIT
                                ? Colors.blue
                                : s.status == ShipmentStatus.DELIVERED ||
                                        s.status == ShipmentStatus.COMPLETED
                                    ? Colors.green
                                    : Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- Dates row ---
            Row(
              children: <Widget>[
                const SizedBox(width: 76.0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Pick-up date\n',
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.hintColor,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: getPickUpDate() != null
                              ? DateFormat.yMMMd().format(getPickUpDate()!)
                              : 'N/A',
                          style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Delivery date\n',
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.hintColor,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: getDeliveryDate() != null
                              ? DateFormat.yMMMd().format(getDeliveryDate()!)
                              : 'N/A',
                          style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),

            // --- Driver row ---
            // --- Driver Info Section ---
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.05), // subtle tint
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: theme.primaryColor.withOpacity(0.2)),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: theme.primaryColor.withOpacity(0.15),
                      child: Icon(Icons.local_shipping,
                          color: theme.primaryColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.driver.user?.name ?? 'N/A',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColorDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "License: ${s.driver.licenseNumber ?? 'N/A'}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Vehicle: ${s.driver.vehicleType ?? 'Unknown'}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Footer route ---
            Container(
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xfffafafa),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 90),
                    child: Text(getOriginCity(),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall),
                  ),
                  Icon(Icons.location_on,
                      color: theme.primaryColor.withOpacity(0.4), size: 21.0),
                  Text("•••••••",
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: theme.hoverColor.withOpacity(0.7))),
                  Icon(Icons.navigation,
                      color: theme.primaryColor.withOpacity(0.4), size: 21.0),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 90),
                    child: Text(getDestinationCity(),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
