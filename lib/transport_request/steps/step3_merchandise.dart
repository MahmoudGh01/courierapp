import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/enums.dart';
import '../../Theme/colors.dart';
import '../../ViewModels/transport_request_provider.dart';
import '../../Models/merchandise_items.dart';

class Step3Merchandise extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const Step3Merchandise({super.key, required this.onNext, required this.onBack});

  @override
  State<Step3Merchandise> createState() => _Step3MerchandiseState();
}

class _Step3MerchandiseState extends State<Step3Merchandise> {
  static const List<String> _categories = [
    'Desk',
    'Box',
    'Cardboard',
    'Pallet',
    'Mattress',
    'Sofa',
    'Wardrobe',
    'Cabinet',
    'Furniture'
  ];

  String _selectedToAdd = _categories.first;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TransportRequestProvider>();
    final merch = p.dto.merchandise!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Step 3 of 8 — Merchandise Details',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // --- Category dropdown + add
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedToAdd,
                      decoration: InputDecoration(
                        labelText: 'Item type',
                        filled: true,
                        fillColor: kButtonColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedToAdd = v ?? _categories.first),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final prov = context.read<TransportRequestProvider>();
                      switch (_selectedToAdd) {
                        case 'Desk':
                          prov.addDesk(DeskModel(weight: 0, length: 0, width: 0, height: 0));
                          break;
                        case 'Box':
                          prov.addBox(BoxModel(weight: 0, length: 0, width: 0, height: 0));
                          break;
                        case 'Cardboard':
                          prov.addCardboard(CardboardModel(
                              weight: 0, length: 0, width: 0, height: 0, isFragile: false));
                          break;
                        case 'Pallet':
                          prov.addPallet(PalletModel(
                              weight: 0, length: 0, width: 0, height: 0, type: 'MINI'));
                          break;
                        case 'Mattress':
                          prov.addMattress(MattressModel(weight: 0, length: 0, width: 0));
                          break;
                        case 'Sofa':
                          prov.addSofa(SofaModel(weight: 0, length: 0, width: 0, height: 0));
                          break;
                        case 'Wardrobe':
                          prov.addWardrobe(WardrobeModel(weight: 0, length: 0, width: 0, height: 0));
                          break;
                        case 'Cabinet':
                          prov.addCabinet(CabinetModel(weight: 0, length: 0, width: 0, height: 0));
                          break;
                        case 'Furniture':
                          prov.addFurniture(FurnitureModel(
                              weight: 0, length: 0, width: 0, height: 0, isFragile: false));
                          break;
                      }
                    },
                    child: const Text('Add item'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- Items list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (int i = 0; i < merch.desks.length; i++) _deskCard(context, i, merch.desks[i]),
                  for (int i = 0; i < merch.boxes.length; i++) _boxCard(context, i, merch.boxes[i]),
                  for (int i = 0; i < merch.cardboards.length; i++)
                    _cardboardCard(context, i, merch.cardboards[i]),
                  for (int i = 0; i < merch.pallets.length; i++)
                    _palletCard(context, i, merch.pallets[i]),
                  for (int i = 0; i < merch.mattresses.length; i++)
                    _mattressCard(context, i, merch.mattresses[i]),
                  for (int i = 0; i < merch.sofas.length; i++) _sofaCard(context, i, merch.sofas[i]),
                  for (int i = 0; i < merch.wardrobes.length; i++)
                    _wardrobeCard(context, i, merch.wardrobes[i]),
                  for (int i = 0; i < merch.cabinets.length; i++)
                    _cabinetCard(context, i, merch.cabinets[i]),
                  for (int i = 0; i < merch.otherFurniture.length; i++)
                    _furnitureCard(context, i, merch.otherFurniture[i]),

                  const SizedBox(height: 16),
                  Text("Quick Item Counters", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  _buildCounterRow(context, "Air Conditioners", merch.airConditioners ?? 0,
                      onChanged: (v) => p.setMerchField(airConditioners: v)),
                  _buildCounterRow(context, "Desk Chairs", merch.deskChairs ?? 0,
                      onChanged: (v) => p.setMerchField(deskChairs: v)),
                  _buildCounterRow(context, "Chairs", merch.chairs ?? 0,
                      onChanged: (v) => p.setMerchField(chairs: v)),
                  _buildCounterRow(context, "Washing Machines", merch.washingMachines ?? 0,
                      onChanged: (v) => p.setMerchField(washingMachines: v)),
                  _buildCounterRow(context, "Dish Washers", merch.dishWashingMachines ?? 0,
                      onChanged: (v) => p.setMerchField(dishWashingMachines: v)),
                  _buildCounterRow(context, "Refrigerators", merch.refrigerators ?? 0,
                      onChanged: (v) => p.setMerchField(refrigerators: v)),
                  _buildCounterRow(context, "Televisions", merch.televisions ?? 0,
                      onChanged: (v) => p.setMerchField(televisions: v)),
                  _buildCounterRow(context, "Microwaves", merch.microwaves ?? 0,
                      onChanged: (v) => p.setMerchField(microwaves: v)),
                  _buildCounterRow(context, "Ovens", merch.ovens ?? 0,
                      onChanged: (v) => p.setMerchField(ovens: v)),
                  _buildCounterRow(context, "Single Place Beds", merch.singlePlaceBed ?? 0,
                      onChanged: (v) => p.setMerchField(singlePlaceBed: v)),
                  _buildCounterRow(context, "Double Place Beds", merch.doublePlaceBed ?? 0,
                      onChanged: (v) => p.setMerchField(doublePlaceBed: v)),
                  _buildCounterRow(context, "Master Bedrooms", merch.masterBedrooms ?? 0,
                      onChanged: (v) => p.setMerchField(masterBedrooms: v)),
                  _buildCounterRow(context, "Dressing Tables", merch.dressingTables ?? 0,
                      onChanged: (v) => p.setMerchField(dressingTables: v)),
                ],
              ),
            ),

            // --- Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  OutlinedButton(onPressed: widget.onBack, child: const Text('Back')),
                  const Spacer(),
                  ElevatedButton(onPressed: widget.onNext, child: const Text('Continue ↓')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helpers ---
  Widget _buildCardWithActions(String title, int index, List<Widget> fields,
      {required VoidCallback onDuplicate, required VoidCallback onRemove}) {
    return _buildCard(title, [
      Row(
        children: [
          Text("$title #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          TextButton(
            onPressed: onDuplicate,
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text("Duplicate"),
          ),
          TextButton(
            onPressed: onRemove,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Remove"),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ...fields,
    ]);
  }

  Widget _buildCard(String title, List<Widget> fields) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fields,
      ),
    );
  }

  Widget _numField(String label, String initialValue, void Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: kButtonColor,
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  // --- Specialized cards with numbering ---
  Widget _deskCard(BuildContext ctx, int idx, DeskModel d) => _buildCardWithActions("Desk", idx, [
    _numField("Weight (kg)", d.weight.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateDesk(idx, d.copyWith(weight: double.tryParse(v) ?? d.weight))),
    _numField("Length (cm)", d.length.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateDesk(idx, d.copyWith(length: double.tryParse(v) ?? d.length))),
    _numField("Width (cm)", d.width.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateDesk(idx, d.copyWith(width: double.tryParse(v) ?? d.width))),
    _numField("Height (cm)", d.height.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateDesk(idx, d.copyWith(height: double.tryParse(v) ?? d.height))),
  ],
      onDuplicate: () => ctx.read<TransportRequestProvider>().addDesk(d.copyWith()),
      onRemove: () => ctx.read<TransportRequestProvider>().removeDesk(idx));

  Widget _boxCard(BuildContext ctx, int idx, BoxModel b) => _buildCardWithActions("Box", idx, [
    _numField("Weight (kg)", b.weight.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateBox(idx, b.copyWith(weight: double.tryParse(v) ?? b.weight))),
    _numField("Length (cm)", b.length.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateBox(idx, b.copyWith(length: double.tryParse(v) ?? b.length))),
    _numField("Width (cm)", b.width.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateBox(idx, b.copyWith(width: double.tryParse(v) ?? b.width))),
    _numField("Height (cm)", b.height.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateBox(idx, b.copyWith(height: double.tryParse(v) ?? b.height))),
  ],
      onDuplicate: () => ctx.read<TransportRequestProvider>().addBox(b.copyWith()),
      onRemove: () => ctx.read<TransportRequestProvider>().removeBox(idx));

  Widget _cardboardCard(BuildContext ctx, int idx, CardboardModel c) =>
      _buildCardWithActions("Cardboard", idx, [
        _numField("Weight (kg)", c.weight.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateCardboard(idx, c.copyWith(weight: double.tryParse(v) ?? c.weight))),
        _numField("Length (cm)", c.length.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateCardboard(idx, c.copyWith(length: double.tryParse(v) ?? c.length))),
        _numField("Width (cm)", c.width.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateCardboard(idx, c.copyWith(width: double.tryParse(v) ?? c.width))),
        _numField("Height (cm)", c.height.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateCardboard(idx, c.copyWith(height: double.tryParse(v) ?? c.height))),
        Row(
          children: [
            Checkbox(
              value: c.isFragile,
              onChanged: (v) => ctx.read<TransportRequestProvider>().updateCardboard(idx, c.copyWith(isFragile: v ?? false)),
            ),
            const Text("Fragile"),
          ],
        )
      ],
          onDuplicate: () => ctx.read<TransportRequestProvider>().addCardboard(c.copyWith()),
          onRemove: () => ctx.read<TransportRequestProvider>().removeCardboard(idx));

  Widget _palletCard(BuildContext ctx, int idx, PalletModel p) =>
      _buildCardWithActions("Pallet", idx, [
        _numField("Weight (kg)", p.weight.toString(),
                (v) => ctx.read<TransportRequestProvider>().updatePallet(idx, p.copyWith(weight: double.tryParse(v) ?? p.weight))),
        _numField("Length (cm)", p.length.toString(),
                (v) => ctx.read<TransportRequestProvider>().updatePallet(idx, p.copyWith(length: double.tryParse(v) ?? p.length))),
        _numField("Width (cm)", p.width.toString(),
                (v) => ctx.read<TransportRequestProvider>().updatePallet(idx, p.copyWith(width: double.tryParse(v) ?? p.width))),
        _numField("Height (cm)", p.height.toString(),
                (v) => ctx.read<TransportRequestProvider>().updatePallet(idx, p.copyWith(height: double.tryParse(v) ?? p.height))),
        DropdownButtonFormField<PalletType>(
          value: PalletType.values.firstWhere((e) => e.name == p.type, orElse: () => PalletType.MINI),
          decoration: InputDecoration(
            labelText: "Pallet Type",
            filled: true,
            fillColor: kButtonColor,
            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
          ),
          items: PalletType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
          onChanged: (val) {
            if (val != null) {
              ctx.read<TransportRequestProvider>().updatePallet(idx, p.copyWith(type: val.name));
            }
          },
        )
      ],
          onDuplicate: () => ctx.read<TransportRequestProvider>().addPallet(p.copyWith()),
          onRemove: () => ctx.read<TransportRequestProvider>().removePallet(idx));

  Widget _mattressCard(BuildContext ctx, int idx, MattressModel m) => _buildCardWithActions("Mattress", idx, [
    _numField("Weight (kg)", m.weight.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateMattress(idx, m.copyWith(weight: double.tryParse(v) ?? m.weight))),
    _numField("Length (cm)", m.length.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateMattress(idx, m.copyWith(length: double.tryParse(v) ?? m.length))),
    _numField("Width (cm)", m.width.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateMattress(idx, m.copyWith(width: double.tryParse(v) ?? m.width))),
  ],
      onDuplicate: () => ctx.read<TransportRequestProvider>().addMattress(m.copyWith()),
      onRemove: () => ctx.read<TransportRequestProvider>().removeMattress(idx));

  Widget _sofaCard(BuildContext ctx, int idx, SofaModel s) => _buildCardWithActions("Sofa", idx, [
    _numField("Weight (kg)", s.weight.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateSofa(idx, s.copyWith(weight: double.tryParse(v) ?? s.weight))),
    _numField("Length (cm)", s.length.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateSofa(idx, s.copyWith(length: double.tryParse(v) ?? s.length))),
    _numField("Width (cm)", s.width.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateSofa(idx, s.copyWith(width: double.tryParse(v) ?? s.width))),
    _numField("Height (cm)", s.height.toString(),
            (v) => ctx.read<TransportRequestProvider>().updateSofa(idx, s.copyWith(height: double.tryParse(v) ?? s.height))),
  ],
      onDuplicate: () => ctx.read<TransportRequestProvider>().addSofa(s.copyWith()),
      onRemove: () => ctx.read<TransportRequestProvider>().removeSofa(idx));

  Widget _wardrobeCard(BuildContext ctx, int idx, WardrobeModel w) =>
      _buildCardWithActions("Wardrobe", idx, [
        _numField("Weight (kg)", w.weight.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateWardrobe(idx, w.copyWith(weight: double.tryParse(v) ?? w.weight))),
        _numField("Length (cm)", w.length.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateWardrobe(idx, w.copyWith(length: double.tryParse(v) ?? w.length))),
        _numField("Width (cm)", w.width.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateWardrobe(idx, w.copyWith(width: double.tryParse(v) ?? w.width))),
        _numField("Height (cm)", w.height.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateWardrobe(idx, w.copyWith(height: double.tryParse(v) ?? w.height))),
      ],
          onDuplicate: () => ctx.read<TransportRequestProvider>().addWardrobe(w.copyWith()),
          onRemove: () => ctx.read<TransportRequestProvider>().removeWardrobe(idx));

  Widget _cabinetCard(BuildContext ctx, int idx, CabinetModel c) =>
      _buildCardWithActions("Cabinet", idx, [
        _numField("Weight (kg)", c.weight.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateCabinet(idx, c.copyWith(weight: double.tryParse(v) ?? c.weight))),
        _numField("Length (cm)", c.length.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateCabinet(idx, c.copyWith(length: double.tryParse(v) ?? c.length))),
        _numField("Width (cm)", c.width.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateCabinet(idx, c.copyWith(width: double.tryParse(v) ?? c.width))),
        _numField("Height (cm)", c.height.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateCabinet(idx, c.copyWith(height: double.tryParse(v) ?? c.height))),
      ],
          onDuplicate: () => ctx.read<TransportRequestProvider>().addCabinet(c.copyWith()),
          onRemove: () => ctx.read<TransportRequestProvider>().removeCabinet(idx));

  Widget _furnitureCard(BuildContext ctx, int idx, FurnitureModel f) =>
      _buildCardWithActions("Furniture", idx, [
        TextFormField(
          initialValue: f.description ?? '',
          onChanged: (v) => ctx.read<TransportRequestProvider>().updateFurniture(idx, f.copyWith(description: v)),
          decoration: InputDecoration(
            labelText: "Description",
            filled: true,
            fillColor: kButtonColor,
            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        _numField("Weight (kg)", f.weight.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateFurniture(idx, f.copyWith(weight: double.tryParse(v) ?? f.weight))),
        _numField("Length (cm)", f.length.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateFurniture(idx, f.copyWith(length: double.tryParse(v) ?? f.length))),
        _numField("Width (cm)", f.width.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateFurniture(idx, f.copyWith(width: double.tryParse(v) ?? f.width))),
        _numField("Height (cm)", f.height.toString(),
                (v) => ctx.read<TransportRequestProvider>().updateFurniture(idx, f.copyWith(height: double.tryParse(v) ?? f.height))),
        Row(
          children: [
            Checkbox(
              value: f.isFragile,
              onChanged: (v) => ctx.read<TransportRequestProvider>().updateFurniture(idx, f.copyWith(isFragile: v ?? false)),
            ),
            const Text("Fragile"),
          ],
        ),
      ],
          onDuplicate: () => ctx.read<TransportRequestProvider>().addFurniture(f.copyWith()),
          onRemove: () => ctx.read<TransportRequestProvider>().removeFurniture(idx));
}

Widget _buildCounterRow(BuildContext ctx, String label, int value,
    {required void Function(int) onChanged}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: kButtonColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          color: Colors.red,
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
        ),
        Text("$value / 100", style: const TextStyle(fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: Colors.green,
          onPressed: value < 100 ? () => onChanged(value + 1) : null,
        ),
      ],
    ),
  );
}
