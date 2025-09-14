import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                          prov.addDesk(DeskModel(weight: 0.0, length: 0.0, width: 0.0, height: 0.0));
                          break;
                        case 'Box':
                          prov.addBox(BoxModel(weight: 0.0, length: 0.0, width: 0.0, height: 0.0));
                          break;
                        case 'Cardboard':
                          prov.addCardboard(CardboardModel(weight: 0.0, length: 0.0, width: 0.0, height: 0.0, isFragile: false));
                          break;
                        case 'Pallet':
                          prov.addPallet(PalletModel(weight: 0.0, length: 0.0, width: 0.0, height: 0.0, type: 'MINI'));
                          break;
                        case 'Mattress':
                          prov.addMattress(MattressModel(weight: 0.0, length: 0.0, width: 0.0));
                          break;
                        case 'Sofa':
                          prov.addSofa(SofaModel(weight: 0.0, length: 0.0, width: 0.0, height: 0.0));
                          break;
                        case 'Wardrobe':
                          prov.addWardrobe(WardrobeModel(weight: 0.0, length: 0.0, width: 0.0, height: 0.0));
                          break;
                        case 'Cabinet':
                          prov.addCabinet(CabinetModel(weight: 0.0, length: 0.0, width: 0.0, height: 0.0));
                          break;
                        case 'Furniture':
                          prov.addFurniture(FurnitureModel(weight: 0.0, length: 0.0, width: 0.0, height: 0.0, isFragile: false));
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
                  for (int i = 0; i < merch.cardboards.length; i++) _cardboardCard(context, i, merch.cardboards[i]),
                  for (int i = 0; i < merch.pallets.length; i++) _palletCard(context, i, merch.pallets[i]),
                  for (int i = 0; i < merch.mattresses.length; i++) _mattressCard(context, i, merch.mattresses[i]),
                  // add others (sofa, wardrobe, cabinet, furniture) in same pattern
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

  // ---- Specialized cards ----
  Widget _deskCard(BuildContext ctx, int idx, DeskModel d) {
    final wCtrl = TextEditingController(text: d.weight.toString());
    final lCtrl = TextEditingController(text: d.length.toString());
    final wiCtrl = TextEditingController(text: d.width.toString());
    final hCtrl = TextEditingController(text: d.height.toString());

    void _upd() {
      ctx.read<TransportRequestProvider>().updateDesk(idx, DeskModel(
        weight: double.tryParse(wCtrl.text) ?? d.weight,
        length: double.tryParse(lCtrl.text) ?? d.length,
        width: double.tryParse(wiCtrl.text) ?? d.width,
        height: double.tryParse(hCtrl.text) ?? d.height,
      ));
    }

    return _buildCard("Desk", [
      _numField("Weight (kg)", wCtrl, _upd),
      _numField("Length (cm)", lCtrl, _upd),
      _numField("Width (cm)", wiCtrl, _upd),
      _numField("Height (cm)", hCtrl, _upd),
    ]);
  }

  Widget _boxCard(BuildContext ctx, int idx, BoxModel b) {
    final wCtrl = TextEditingController(text: b.weight.toString());
    final lCtrl = TextEditingController(text: b.length.toString());
    final wiCtrl = TextEditingController(text: b.width.toString());
    final hCtrl = TextEditingController(text: b.height.toString());

    void _upd() {
      ctx.read<TransportRequestProvider>().updateBox(idx, BoxModel(
        weight: double.tryParse(wCtrl.text) ?? b.weight,
        length: double.tryParse(lCtrl.text) ?? b.length,
        width: double.tryParse(wiCtrl.text) ?? b.width,
        height: double.tryParse(hCtrl.text) ?? b.height,
      ));
    }

    return _buildCard("Box", [
      _numField("Weight (kg)", wCtrl, _upd),
      _numField("Length (cm)", lCtrl, _upd),
      _numField("Width (cm)", wiCtrl, _upd),
      _numField("Height (cm)", hCtrl, _upd),
    ]);
  }

  Widget _cardboardCard(BuildContext ctx, int idx, CardboardModel c) {
    final wCtrl = TextEditingController(text: c.weight.toString());
    final lCtrl = TextEditingController(text: c.length.toString());
    final wiCtrl = TextEditingController(text: c.width.toString());
    final hCtrl = TextEditingController(text: c.height.toString());

    void _upd() {
      ctx.read<TransportRequestProvider>().updateCardboard(idx, c.copyWith(
        weight: double.tryParse(wCtrl.text) ?? c.weight,
        length: double.tryParse(lCtrl.text) ?? c.length,
        width: double.tryParse(wiCtrl.text) ?? c.width,
        height: double.tryParse(hCtrl.text) ?? c.height,
      ));
    }

    return _buildCard("Cardboard", [
      _numField("Weight (kg)", wCtrl, _upd),
      _numField("Length (cm)", lCtrl, _upd),
      _numField("Width (cm)", wiCtrl, _upd),
      _numField("Height (cm)", hCtrl, _upd),
      Row(
        children: [
          Checkbox(
            value: c.isFragile,
            onChanged: (v) => ctx.read<TransportRequestProvider>().updateCardboard(idx, c.copyWith(isFragile: v ?? false)),
          ),
          const Text("Fragile"),
        ],
      ),
    ]);
  }

  Widget _palletCard(BuildContext ctx, int idx, PalletModel p) {
    final wCtrl = TextEditingController(text: p.weight.toString());
    final lCtrl = TextEditingController(text: p.length.toString());
    final wiCtrl = TextEditingController(text: p.width.toString());
    final hCtrl = TextEditingController(text: p.height.toString());

    void _upd() {
      ctx.read<TransportRequestProvider>().updatePallet(idx, p.copyWith(
        weight: double.tryParse(wCtrl.text) ?? p.weight,
        length: double.tryParse(lCtrl.text) ?? p.length,
        width: double.tryParse(wiCtrl.text) ?? p.width,
        height: double.tryParse(hCtrl.text) ?? p.height,
      ));
    }

    return _buildCard("Pallet", [
      _numField("Weight (kg)", wCtrl, _upd),
      _numField("Length (cm)", lCtrl, _upd),
      _numField("Width (cm)", wiCtrl, _upd),
      _numField("Height (cm)", hCtrl, _upd),
      Text("Type: ${p.type}"),
    ]);
  }

  Widget _mattressCard(BuildContext ctx, int idx, MattressModel m) {
    final wCtrl = TextEditingController(text: m.weight.toString());
    final lCtrl = TextEditingController(text: m.length.toString());
    final wiCtrl = TextEditingController(text: m.width.toString());

    void _upd() {
      ctx.read<TransportRequestProvider>().updateMattress(idx, MattressModel(
        weight: double.tryParse(wCtrl.text) ?? m.weight,
        length: double.tryParse(lCtrl.text) ?? m.length,
        width: double.tryParse(wiCtrl.text) ?? m.width,
      ));
    }

    return _buildCard("Mattress", [
      _numField("Weight (kg)", wCtrl, _upd),
      _numField("Length (cm)", lCtrl, _upd),
      _numField("Width (cm)", wiCtrl, _upd),
    ]);
  }

  // --- helpers ---
  Widget _buildCard(String title, List<Widget> fields) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...fields,
        ],
      ),
    );
  }

  Widget _numField(String label, TextEditingController ctrl, void Function() onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        onChanged: (_) => onChanged(),
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
}
