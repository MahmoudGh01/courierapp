import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Theme/colors.dart';
import '../../ViewModels/transport_request_provider.dart';
import '../../models/merchandise_item.dart';

class Step3Merchandise extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const Step3Merchandise({super.key, required this.onNext, required this.onBack});

  @override
  State<Step3Merchandise> createState() => _Step3MerchandiseState();
}

class _Step3MerchandiseState extends State<Step3Merchandise> {
  // -- categories list (dropdown source)
  static const List<String> _categories = ['Cardboards', 'Desks', 'Cabinets'];

  // -- current category for "Add item"
  String _selectedToAdd = _categories.first;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TransportRequestProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: kWhiteColor, // ✅ light background (readable)
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Step 3 of 8 — Merchandise Details',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // --- Add item (Dropdown + Add button) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Dropdown to choose item type
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
                          .map((c) => DropdownMenuItem<String>(
                        value: c,
                        child: Text(c),
                      ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedToAdd = v ?? _categories.first),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      // add with chosen category
                      context.read<TransportRequestProvider>().addItem(
                        MerchandiseItem(category: _selectedToAdd),
                      );
                    },
                    child: const Text('Add item'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- Items list ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: p.dto.items.length,
                itemBuilder: (_, i) {
                  final it = p.dto.items[i];
                  return _itemCard(context, i, it);
                },
              ),
            ),

            // --- Footer: back / totals / continue ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Total W: ${p.dto.totalWeightKg.toStringAsFixed(2)} kg • Vol: ${p.dto.totalVolumeM3.toStringAsFixed(3)} m³',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      OutlinedButton(onPressed: widget.onBack, child: const Text('Back')),
                      const Spacer(),

                      const SizedBox(width: 12),
                      ElevatedButton(onPressed: widget.onNext, child: const Text('Continue  ↓')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Single item card ----
  Widget _itemCard(BuildContext ctx, int idx, MerchandiseItem it) {
    final theme = Theme.of(ctx);

    // Controllers per card (simple approach; if list is big, migrate to TextEditingControllers cache)
    final wCtrl  = TextEditingController(text: it.weightKg.toString());
    final lCtrl  = TextEditingController(text: it.lengthCm.toString());
    final wiCtrl = TextEditingController(text: it.widthCm.toString());
    final hCtrl  = TextEditingController(text: it.heightCm.toString());

    // helper to push updates to provider
    void _upd({String? newCategory, bool? newFragile}) {
      ctx.read<TransportRequestProvider>().updateItem(
        idx,
        MerchandiseItem(
          category: newCategory ?? it.category,
          weightKg: double.tryParse(wCtrl.text) ?? it.weightKg,
          lengthCm: double.tryParse(lCtrl.text) ?? it.lengthCm,
          widthCm: double.tryParse(wiCtrl.text) ?? it.widthCm,
          heightCm: double.tryParse(hCtrl.text) ?? it.heightCm,
          fragile: newFragile ?? it.fragile,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header: Category dropdown + duplicate/remove actions ---
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: it.category,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    filled: true,
                    fillColor: kButtonColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem<String>(
                    value: c,
                    child: Text(c),
                  ))
                      .toList(),
                  onChanged: (cat) => _upd(newCategory: cat),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => ctx.read<TransportRequestProvider>().duplicateItem(idx),
                child: const Text('Duplicate'),
              ),
              TextButton(
                onPressed: () => ctx.read<TransportRequestProvider>().removeItem(idx),
                child: const Text('Remove'),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // --- Row 1: Weight / Length ---
          Row(
            children: [
              Expanded(child: _numField('Weight (kg)', wCtrl, onChanged: (_) => _upd())),
              const SizedBox(width: 10),
              Expanded(child: _numField('Length (cm)', lCtrl, onChanged: (_) => _upd())),
            ],
          ),
          const SizedBox(height: 10),

          // --- Row 2: Width / Height ---
          Row(
            children: [
              Expanded(child: _numField('Width (cm)', wiCtrl, onChanged: (_) => _upd())),
              const SizedBox(width: 10),
              Expanded(child: _numField('Height (cm)', hCtrl, onChanged: (_) => _upd())),
            ],
          ),
          const SizedBox(height: 8),

          // --- Fragile toggle ---
          Row(
            children: [
              Checkbox(
                value: it.fragile,
                onChanged: (v) => _upd(newFragile: v ?? false),
              ),
              const Text('Fragile object'),
            ],
          ),
        ],
      ),
    );
  }

  // ---- Numeric filled field (consistent UI) ----
  Widget _numField(
      String label,
      TextEditingController ctrl, {
        required ValueChanged<String> onChanged,
      }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: kButtonColor,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
