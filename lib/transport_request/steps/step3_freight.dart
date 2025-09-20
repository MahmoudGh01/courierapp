import 'package:courier_app/Models/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Theme/colors.dart';
import '../../ViewModels/transport_request_provider.dart';

class Step3Freight extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const Step3Freight({super.key, required this.onNext, required this.onBack});

  @override
  State<Step3Freight> createState() => _Step3FreightState();
}

class _Step3FreightState extends State<Step3Freight> {


  @override
  Widget build(BuildContext context) {
    final p = context.watch<TransportRequestProvider>();
    final dto = p.dto;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Title ----
              Text(
                'Step 3 of 8 — Merchandise Details',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text("Enter the details of the merchandise.",
                  style: theme.textTheme.bodyMedium),

              const SizedBox(height: 16),

              // ---- Merchandise Type ----
              // ---- Merchandise Type ----
              Text("Merchandise Type", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<MerchandiseType>(
                value: dto.merchandise?.merchandiseType != null
                    ? MerchandiseType.values.firstWhere(
                      (t) => t.name == dto.merchandise!.merchandiseType,
                  orElse: () => MerchandiseType.GENERAL_GOODS,
                )
                    : MerchandiseType.GENERAL_GOODS,
                items: MerchandiseType.values.map((MerchandiseType type) {
                  return DropdownMenuItem<MerchandiseType>(
                    value: type,
                    child: Text(type.name.replaceAll('_', ' ')),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    p.setMerchField(merchandiseType: v.name); // ✅ wire provider
                  }
                },
                decoration: _inputDecoration("Select merchandise type"),
              ),
              const SizedBox(height: 12),


              // ---- Description ----
              TextFormField(
                initialValue: dto.merchandise?.description ?? '',
                maxLines: 2,
                decoration: _inputDecoration("Description"),
                onChanged: (v) => p.setMerchField(description: v),
              ),

              const SizedBox(height: 16),

              // ---- Loading Type ----
              // ---- Loading Type ----
              Text("Loading Type", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  _choiceChip("Full Container Load", dto.merchandise?.loadingType == LoadingType.FULL_CONTAINER.name, () {
                    p.setMerchField(loadingType: LoadingType.FULL_CONTAINER.name); // ✅ wire provider
                  }),
                  const SizedBox(width: 12),
                  _choiceChip("Partial Load", dto.merchandise?.loadingType == LoadingType.PARTIAL.name, () {
                    p.setMerchField(loadingType: LoadingType.PARTIAL.name); // ✅ wire provider
                  }),
                ],
              ),


              const SizedBox(height: 16),

              if (dto.merchandise?.loadingType == LoadingType.FULL_CONTAINER.name) _buildFclSection(context) else _buildLclSection(context),

              const SizedBox(height: 20),

              // ---- Requirements ----
              Text("Requirements", style: theme.textTheme.titleMedium),
              _checkBoxRow(
                  "Special treatment necessary",
                  dto.merchandise?.isSpecialHandlingRequired ?? false,
                      (v) => p.setMerchField(isSpecialHandlingRequired: v)),
              _checkBoxRow(
                  "Additional protection necessary",
                  dto.merchandise?.isAdditionalProtectionRequired ?? false,
                      (v) => p.setMerchField(isAdditionalProtectionRequired: v)),
              _checkBoxRow(
                  "Vehicle needs tailgate lift",
                  dto.merchandise?.isVehicleWithTailElevatorRequired ?? false,
                      (v) => p.setMerchField(isVehicleWithTailElevatorRequired: v)),

              TextFormField(
                initialValue: dto.merchandise?.other ?? '',
                decoration: _inputDecoration("Other requirements"),
                onChanged: (v) => p.setMerchField(otherRequirements: v),
              ),

              const SizedBox(height: 40),

              // ---- Footer ----
              Row(
                children: [
                  OutlinedButton(onPressed: widget.onBack, child: const Text("Back")),
                  const Spacer(),
                  ElevatedButton(onPressed: widget.onNext, child: const Text("Continue ↓")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- HELPERS -----------------

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: kButtonColor,
    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
  );

  Widget _choiceChip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }

  Widget _checkBoxRow(String label, bool value, Function(bool) onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  // FCL Section
  Widget _buildFclSection(BuildContext ctx) {
    final p = ctx.watch<TransportRequestProvider>();
    final m = p.dto.merchandise!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _counter(Icons.inventory, "Standard 20 Feet Containers",
            m.standard20FeetContainersNumber ?? 0,
                (v) => p.setMerchField(standard20ft: v), max: 100),
        _counter(Icons.inventory_2, "Standard 40 Feet Containers",
            m.standard40FeetContainersNumber ?? 0,
                (v) => p.setMerchField(standard40ft: v), max: 100),
        _counter(Icons.warehouse, "High Cube 40 Feet Containers",
            m.highCube40FeetContainersNumber ?? 0,
                (v) => p.setMerchField(highCube40ft: v), max: 100),
        const SizedBox(height: 12),
        _numField(Icons.scale, "Total Weight (kg)", m.totalWeight?.toString() ?? "0",
                (v) => p.setMerchField(totalWeight: double.tryParse(v))),
        _numField(Icons.straighten, "Total Volume (m³)", m.totalVolume?.toString() ?? "0",
                (v) => p.setMerchField(totalVolume: double.tryParse(v))),
      ],
    );
  }

  // LCL Section
  Widget _buildLclSection(BuildContext ctx) {
    final p = ctx.watch<TransportRequestProvider>();
    final m = p.dto.merchandise!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _counter(Icons.local_shipping, "Pallets", m.pallets.length ?? 0,
                (v) => p.setMerchField(palletCount: v), max: 200),
        _counter(Icons.all_inbox, "Boxes", m.boxes.length ?? 0,
                (v) => p.setMerchField(boxCount: v), max: 200),

        const SizedBox(height: 12),
        _numField(Icons.scale, "Total Weight (kg)", m.totalWeight?.toString() ?? "0",
                (v) => p.setMerchField(totalWeight: double.tryParse(v))),
        _numField(Icons.straighten, "Total Volume (m³)", m.totalVolume?.toString() ?? "0",
                (v) => p.setMerchField(totalVolume: double.tryParse(v))),
      ],
    );
  }

  Widget _counter(IconData icon, String label, int value, Function(int) onChanged, {int max = 100}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: kButtonColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: value > 0 ? () => onChanged(value - 1) : null,
          ),
          Text("$value / $max", style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _numField(IconData icon, String label, String initialValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        decoration: _inputDecoration(label).copyWith(
          prefixIcon: Icon(icon, color: Colors.blueGrey),
        ),
      ),
    );
  }
}
