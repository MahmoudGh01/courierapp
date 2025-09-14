import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Theme/colors.dart';
import '../../ViewModels/transport_request_provider.dart';
import '../../Models/enums.dart';

class Step4Vehicle extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const Step4Vehicle({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final p     = context.watch<TransportRequestProvider>();
    final theme = Theme.of(context);

    final maxW = TextEditingController(text: p.dto.maxWidth?.toString() ?? '');
    final maxH = TextEditingController(text: p.dto.maxHeight?.toString() ?? '');

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Step 4 of 8 — Vehicle Information',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),

                      // Vehicle Type
                      Text('Vehicle Type', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      _optionRow(
                        context: context,
                        items: [
                          _VehicleOption(
                            selected: p.dto.vehicleType == VehicleType.SEMI_TRAILER.name,
                            icon: Icons.local_shipping,
                            title: 'Semi-Trailer',
                            subtitle: 'Truck for transporting large cargo.',
                            onTap: () => context.read<TransportRequestProvider>().setVehicle(vehicleType: VehicleType.SEMI_TRAILER.name),
                          ),
                          _VehicleOption(
                            selected: p.dto.vehicleType == VehicleType.TRUCK.name,
                            icon: Icons.fire_truck_outlined,
                            title: 'Truck',
                            subtitle: 'Heavy vehicle for bigger loads.',
                            onTap: () => context.read<TransportRequestProvider>().setVehicle(vehicleType: VehicleType.TRUCK.name),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _optionRow(
                        context: context,
                        items: [
                          _VehicleOption(
                            selected: p.dto.vehicleType == VehicleType.VAN.name,
                            icon: Icons.local_shipping_outlined,
                            title: 'Van',
                            subtitle: 'Mid volume / city friendly.',
                            onTap: () => context.read<TransportRequestProvider>().setVehicle(vehicleType: VehicleType.VAN.name),
                          ),
                          _VehicleOption(
                            selected: p.dto.vehicleType == VehicleType.PICKUP.name,
                            icon: Icons.directions_car_filled_outlined,
                            title: 'Pickup',
                            subtitle: 'Light cargo, flexible access.',
                            onTap: () => context.read<TransportRequestProvider>().setVehicle(vehicleType: VehicleType.PICKUP.name),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Loading Capacity
                      Text('Loading Capacity', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      _optionRow(
                        context: context,
                        items: [
                          _VehicleOption(
                            selected: p.dto.loadingCapacity == LoadingCapacityType.LIGHT_DUTY.name,
                            icon: Icons.inventory_2_outlined,
                            title: 'Light Duty',
                            subtitle: 'Small loads / parcels.',
                            onTap: () => context.read<TransportRequestProvider>().setVehicle(loadingCapacity: LoadingCapacityType.LIGHT_DUTY.name),
                          ),
                          _VehicleOption(
                            selected: p.dto.loadingCapacity == LoadingCapacityType.MEDIUM_DUTY.name,
                            icon: Icons.inventory_outlined,
                            title: 'Medium Duty',
                            subtitle: 'Medium loads, common choice.',
                            onTap: () => context.read<TransportRequestProvider>().setVehicle(loadingCapacity: LoadingCapacityType.MEDIUM_DUTY.name),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _optionRow(
                        context: context,
                        items: [
                          _VehicleOption(
                            selected: p.dto.loadingCapacity == LoadingCapacityType.HEAVY_DUTY.name,
                            icon: Icons.inventory,
                            title: 'Heavy Duty',
                            subtitle: 'Large or heavy loads.',
                            onTap: () => context.read<TransportRequestProvider>().setVehicle(loadingCapacity: LoadingCapacityType.HEAVY_DUTY.name),
                          ),
                          const _VehicleOption.spacer(),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Access Type
                      Text('Access Type', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      _optionRow(
                        context: context,
                        items: [
                          _VehicleOption(
                            selected: p.dto.accessType == AccessType.LARGE_VEHICLE_ACCESS.name,
                            icon: Icons.warehouse_outlined,
                            title: 'Access for Large Vehicles',
                            subtitle: 'Trucks can access the site.',
                            onTap: () => context.read<TransportRequestProvider>().setVehicle(accessType: AccessType.LARGE_VEHICLE_ACCESS.name),
                          ),
                          _VehicleOption(
                            selected: p.dto.accessType == AccessType.LIGHT_VEHICLE_ONLY.name,
                            icon: Icons.directions_car_outlined,
                            title: 'Light Vehicles Only',
                            subtitle: 'Vans / pickups only.',
                            onTap: () => context.read<TransportRequestProvider>().setVehicle(accessType: AccessType.LIGHT_VEHICLE_ONLY.name),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _optionRow(
                        context: context,
                        items: [
                          _VehicleOption(
                            selected: p.dto.accessType == AccessType.HEIGHT_WIDTH_RESTRICTIONS.name,
                            icon: Icons.height,
                            title: 'Restrictions',
                            subtitle: 'Restricted clearance present.',
                            onTap: () => context.read<TransportRequestProvider>().setVehicle(accessType: AccessType.HEIGHT_WIDTH_RESTRICTIONS.name),
                          ),
                          const _VehicleOption.spacer(),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Max dimensions
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: maxW,
                              keyboardType: TextInputType.number,
                              onChanged: (v) => context.read<TransportRequestProvider>().setVehicle(maxW: double.tryParse(v)),
                              decoration: InputDecoration(
                                labelText: 'Max Width (m)',
                                filled: true,
                                fillColor: kButtonColor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: maxH,
                              keyboardType: TextInputType.number,
                              onChanged: (v) => context.read<TransportRequestProvider>().setVehicle(maxH: double.tryParse(v)),
                              decoration: InputDecoration(
                                labelText: 'Max Height (m)',
                                filled: true,
                                fillColor: kButtonColor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Row(
                        children: [
                          OutlinedButton(onPressed: onBack, child: const Text('Back')),
                          const Spacer(),
                          ElevatedButton(onPressed: onNext, child: const Text('Continue  ↓')),
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


/// Helper: 2-wide row of option cards
Widget _optionRow({
  required BuildContext context,
  required List<_VehicleOption> items,
}) {
  return Row(
    children: [
      Expanded(child: _VehicleCard(option: items[0])),
      const SizedBox(width: 12),
      Expanded(child: _VehicleCard(option: items.length > 1 ? items[1] : const _VehicleOption.spacer())),
    ],
  );
}

/// Model for a selectable option
class _VehicleOption {
  final bool selected;
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _VehicleOption({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  const _VehicleOption.spacer()
      : selected = false,
        icon = null,
        title = null,
        subtitle = null,
        onTap = null;
}

/// UI card for a vehicle option
class _VehicleCard extends StatelessWidget {
  final _VehicleOption option;
  const _VehicleCard({required this.option});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (option.title == null) {
      // empty spacer card
      return const SizedBox(height: 108);
    }
    final selected = option.selected;

    return InkWell(
      onTap: option.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 136,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? theme.primaryColor.withOpacity(0.08) : kWhiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? theme.primaryColor : theme.dividerColor.withOpacity(0.25),
            width: selected ? 1.6 : 1.0,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Icon(option.icon, color: theme.primaryColor, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.title!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(option.subtitle!, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle, color: theme.primaryColor),
          ],
        ),
      ),
    );
  }
}
