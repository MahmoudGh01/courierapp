import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/continue_button.dart';
import '../../Theme/colors.dart';
import '../../ViewModels/quick_request_provider.dart';
import '../../locale/locales.dart';

class DetailsStep extends StatefulWidget {
  final VoidCallback onContinue;
  const DetailsStep({super.key, required this.onContinue});

  @override
  State<DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends State<DetailsStep> {
  final _descCtrl = TextEditingController();
  DateTime? _pickupDate;
  DateTime? _deliveryDate;

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final quick = context.watch<QuickRequestProvider>();

    return Container(
      color: kWhiteColor,
      child: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: [
              const SizedBox(height: 8),
              _sectionDivider(),
              ListTile(
                title: Text('Pick-up Date', style: theme.textTheme.bodyLarge),
                trailing: OutlinedButton(
                  onPressed: () async {
                    final date = await _pickDate(context);
                    if (date != null) {
                      setState(() => _pickupDate = date);
                      quick.updateMeta(pickup: date);
                    }
                  },
                  child: Text(
                    _pickupDate == null
                        ? 'Choose date'
                        : _pickupDate!.toIso8601String().substring(0, 10),
                  ),
                ),
              ),
              _sectionDivider(),
              ListTile(
                title: Text('Delivery Date (optional)', style: theme.textTheme.bodyLarge),
                trailing: OutlinedButton(
                  onPressed: () async {
                    final date = await _pickDate(context);
                    if (date != null) {
                      setState(() => _deliveryDate = date);
                      quick.updateMeta(delivery: date);
                    }
                  },
                  child: Text(
                    _deliveryDate == null
                        ? 'Choose date'
                        : _deliveryDate!.toIso8601String().substring(0, 10),
                  ),
                ),
              ),
              _sectionDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('${locale.courierDetail}\n', style: theme.textTheme.bodyLarge),
                    TextField(
                      controller: _descCtrl,
                      maxLines: 2,
                      onChanged: (v) => quick.updateMeta(desc: v),
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: locale.courierInput,
                        hintStyle: theme.textTheme.bodySmall!.copyWith(color: theme.hintColor),
                        filled: true,
                        fillColor: kButtonColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // keep bottom spacing so the floating button doesn't overlap
              const SizedBox(height: 80),
            ],
          ),
          PositionedDirectional(
            end: 15,
            bottom: 40,
            child: CustomButton(
              radius: BorderRadius.circular(35.0),
              padding: 10,
              text: '      ${locale.continueText}  ↓    ',
              onPressed: () {
                if (!quick.isStep3Valid()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('locale.pleaseEnterAllDetails')),
                  );
                  return;
                }
                widget.onContinue();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionDivider() => Divider(thickness: 6, color: kButtonColor);

  Future<DateTime?> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
  }
}
