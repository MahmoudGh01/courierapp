import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Theme/colors.dart';
import '../../ViewModels/transport_request_provider.dart';
import '../../ViewModels/userprovider.dart';
import '../../utils/constants.dart';
import '../../Models/merchandise_model.dart';
import '../../Models/merchandise_items.dart';

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
    final user  = Provider.of<UserProvider>(context, listen: false).user.idUser;
    print(user);
    final p     = context.watch<TransportRequestProvider>();
    context.read<TransportRequestProvider>().setUser(user);
    final theme = Theme.of(context);

    Future<void> _submit() async {
      final payload = p.dto.toJson();
      final prefs   = await SharedPreferences.getInstance();
      final token   = prefs.getString('token') ?? '';

      try {
        var res = await http.post(
          Uri.parse('${Constants.uri}TransportRequest/add-TransportRequest'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(payload),
        );

        if (res.statusCode == 200 || res.statusCode == 201) {
          // ✅ refresh user data so PlanUsageBanner updates
          await context.read<UserProvider>().fetchUserData();
          // (make sure UserProvider has this method calling backend + notifyListeners)

          onSubmitSuccess();
        } else {
          final err = res.body.isNotEmpty ? res.body : 'HTTP ${res.statusCode}';
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Submit failed: $err')),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Network error: $e')),
          );
        }
      }
    }

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

    Widget _sectionCard({required String title, required Widget child}) {
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
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      );
    }

    Widget _kv(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Text(label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Text(value.isEmpty ? '—' : value,
                  style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
      );
    }

    // -- Items table (flatten desks, cabinets, etc.)
    Widget _itemsTable(MerchandiseModel m) {
      final rows = <DataRow>[];

      void addRows<T>(List<T> list, String label, String Function(T) dims, double Function(T) w, [bool Function(T)? fragile]) {
        for (var i = 0; i < list.length; i++) {
          rows.add(DataRow(
            cells: [
              DataCell(Text('$label #${i + 1}')),
              DataCell(Text(dims(list[i]))),
              DataCell(Text(w(list[i]).toStringAsFixed(2))),
              DataCell(Text(fragile != null ? (fragile(list[i]) ? 'Yes' : 'No') : '—')),
            ],
          ));
        }
      }

      addRows<DeskModel>(m.desks, 'Desk',
              (d) => '${d.length}×${d.width}×${d.height}', (d) => d.weight);

      addRows<CabinetModel>(m.cabinets, 'Cabinet',
              (d) => '${d.length}×${d.width}×${d.height}', (d) => d.weight);

      addRows<CardboardModel>(m.cardboards, 'Cardboard',
              (d) => '${d.length}×${d.width}×${d.height}', (d) => d.weight, (d) => d.isFragile);

      addRows<BoxModel>(m.boxes, 'Box',
              (d) => '${d.length}×${d.width}×${d.height}', (d) => d.weight);

      addRows<PalletModel>(m.pallets, 'Pallet',
              (d) => '${d.length}×${d.width}×${d.height}', (d) => d.weight);

      addRows<WardrobeModel>(m.wardrobes, 'Wardrobe',
              (d) => '${d.length}×${d.width}×${d.height}', (d) => d.weight);

      addRows<SofaModel>(m.sofas, 'Sofa',
              (d) => '${d.length}×${d.width}×${d.height}', (d) => d.weight);

      addRows<MattressModel>(m.mattresses, 'Mattress',
              (d) => '${d.length}×${d.width}', (d) => d.weight);

      addRows<FurnitureModel>(m.otherFurniture, 'Furniture',
              (d) => '${d.length}×${d.width}×${d.height}', (d) => d.weight, (d) => d.isFragile);

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Item')),
            DataColumn(label: Text('Dim (cm)')),
            DataColumn(label: Text('Weight (kg)')),
            DataColumn(label: Text('Fragile')),
          ],
          rows: rows,
        ),
      );
    }

    String _fmtDate(DateTime? d) =>
        d == null ? '—' : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    String _fmtTime(String? t) => (t == null || t.isEmpty) ? '—' : t;

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text('Step 7 of 8 — Summary', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),

              // Service
              _sectionCard(
                title: 'Service Type',
                child: _pill(p.dto.serviceType),
              ),

              // Locations
              _sectionCard(
                title: 'Locations',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Origin', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    _kv('Address', p.dto.originAddress),
                    _kv('City / State', '${p.dto.originCity} / ${p.dto.originState}'),
                    _kv('Postal Code', p.dto.originPostalCode),
                    _kv('Coordinates', '${p.dto.originLatitude}, ${p.dto.originLongitude}'),
                    const Divider(height: 16),
                    Text('Destination', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    _kv('Address', p.dto.destinationAddress),
                    _kv('City / State', '${p.dto.destinationCity} / ${p.dto.destinationState}'),
                    _kv('Postal Code', p.dto.destinationPostalCode),
                    _kv('Coordinates', '${p.dto.destinationLatitude}, ${p.dto.destinationLongitude}'),
                  ],
                ),
              ),

              // Scheduling
              _sectionCard(
                title: 'Scheduling',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kv('Pick-up Date', _fmtDate(p.dto.pickUpDate)),
                    _kv('Pick-up Time', _fmtTime(p.dto.pickUpTime)),
                    _kv('Delivery Date', _fmtDate(p.dto.deliveryDate)),
                    _kv('Delivery Time', _fmtTime(p.dto.deliveryTime)),
                  ],
                ),
              ),

              // Merchandise
              if (p.dto.merchandise != null) _sectionCard(
                title: 'Merchandise',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kv('Type', p.dto.merchandise!.merchandiseType),
                    _kv('Description', p.dto.merchandise!.description),
                    _kv('Total Weight', '${p.dto.merchandise!.totalWeight ?? 0} kg'),
                    _kv('Total Volume', '${p.dto.merchandise!.totalVolume ?? 0} m³'),
                    const SizedBox(height: 8),
                    Text('Items', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    _itemsTable(p.dto.merchandise!),
                  ],
                ),
              ),

              // Vehicle
              _sectionCard(
                title: 'Vehicle',
                child: Wrap(
                  spacing: 8,
                  children: [
                    _pill('Type: ${p.dto.vehicleType}'),
                    _pill('Capacity: ${p.dto.loadingCapacity}'),
                    _pill('Access: ${p.dto.accessType}'),
                  ],
                ),
              ),

              // Payment
              _sectionCard(
                title: 'Payment',
                child: Wrap(
                  spacing: 8,
                  children: [
                    _pill('Method: ${p.dto.paymentMethod}'),
                    _pill('Condition: ${p.dto.paymentCondition}'),
                  ],
                ),
              ),

              // Additional
              _sectionCard(
                title: 'Additional',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kv('Instructions', p.dto.additionalInstructions ?? '—'),
                    if (p.dto.documentPaths!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Documents', style: theme.textTheme.titleMedium),
                      ...p.dto.documentPaths!.map((d) => Text('• $d')).toList(),
                    ]
                  ],
                ),
              ),

              const SizedBox(height: 24),
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
  }
}
