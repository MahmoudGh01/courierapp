import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Theme/colors.dart';
import '../../ViewModels/transport_request_provider.dart';
import '../../Models/enums.dart';

class Step5Payment extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const Step5Payment({super.key, required this.onNext, required this.onBack});

  @override
  State<Step5Payment> createState() => _Step5PaymentState();
}

class _Step5PaymentState extends State<Step5Payment> {
  late TextEditingController terms;

  @override
  void initState() {
    super.initState();
    final prov = context.read<TransportRequestProvider>();
    terms = TextEditingController(text: prov.dto.otherTerms ?? '');

    // keep provider in sync
    terms.addListener(() {
      prov.setPayment(terms: terms.text);
    });
  }

  @override
  void dispose() {
    terms.dispose();
    super.dispose();
  }

  Widget chip<T>(T current, T value, String label, void Function(T) onSet) {
    final selected = current == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSet(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p     = context.watch<TransportRequestProvider>();
    final theme = Theme.of(context);

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
                        'Step 5 of 8 — Payment Method',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),

                      Text('Payment Method',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          chip<String>(
                            p.dto.paymentMethod,
                            PaymentMethod.CASH_ON_DELIVERY.name,
                            'Cash on delivery',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentMethod: v),
                          ),
                          chip<String>(
                            p.dto.paymentMethod,
                            PaymentMethod.BANK_TRANSFER.name,
                            'Bank transfer',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentMethod: v),
                          ),
                          chip<String>(
                            p.dto.paymentMethod,
                            PaymentMethod.CREDIT_CARD_ON_DELIVERY.name,
                            'Card',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentMethod: v),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Text('Payment Condition',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          chip<String>(
                            p.dto.paymentCondition,
                            PaymentCondition.PAYMENT_ON_RECEIPT.name,
                            'Payment on receipt',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentCondition: v),
                          ),
                          chip<String>(
                            p.dto.paymentCondition,
                            PaymentCondition.ADVANCE_PAYMENT.name,
                            'Advance',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentCondition: v),
                          ),
                          chip<String>(
                            p.dto.paymentCondition,
                            PaymentCondition.INSTALLMENT_PAYMENT.name,
                            'Installments',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentCondition: v),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      TextFormField(
                        controller: terms,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Other Terms (optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 40),

                      Row(
                        children: [
                          OutlinedButton(onPressed: widget.onBack, child: const Text('Back')),
                          const Spacer(),
                          ElevatedButton(onPressed: widget.onNext, child: const Text('Continue  ↓')),
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
