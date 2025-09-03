import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Theme/colors.dart';
import '../../ViewModels/transport_request_provider.dart';
import '../../models/enums.dart';

class Step5Payment extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const Step5Payment({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final p     = context.watch<TransportRequestProvider>();
    final theme = Theme.of(context);

    // ⚠️ Controller reconstruit à chaque build : OK ici car on pousse dans le provider via onChanged()
    final terms = TextEditingController(text: p.dto.otherTerms ?? '');

    Widget chip<T>(T current, T value, String label, void Function(T) onSet) {
      final selected = current == value;
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSet(value),
      );
    }

    return Scaffold(
      backgroundColor: kWhiteColor, // ✅ fond clair comme Step4
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

                      // ---- Titre ----
                      Text(
                        'Step 5 of 8 — Payment Method',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),

                      // ---- Méthode de paiement ----
                      Text('Payment Method', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          chip<PaymentMethod>(
                            p.dto.paymentMethod,
                            PaymentMethod.CASH_ON_DELIVERY,
                            'Cash on delivery.',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentMethod: v),
                          ),
                          chip<PaymentMethod>(
                            p.dto.paymentMethod,
                            PaymentMethod.BANK_TRANSFER,
                            'Bank transfer',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentMethod: v),
                          ),
                          chip<PaymentMethod>(
                            p.dto.paymentMethod,
                            PaymentMethod.CARD,
                            'Card',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentMethod: v),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ---- Condition de paiement ----
                      Text('Payment Condition', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          chip<PaymentCondition>(
                            p.dto.paymentCondition,
                            PaymentCondition.PAYMENT_ON_RECEIPT,
                            'Payment on receipt.',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentCondition: v),
                          ),
                          chip<PaymentCondition>(
                            p.dto.paymentCondition,
                            PaymentCondition.ADVANCE,
                            'Advance',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentCondition: v),
                          ),
                          chip<PaymentCondition>(
                            p.dto.paymentCondition,
                            PaymentCondition.NET30,
                            'Net 30',
                                (v) => context.read<TransportRequestProvider>().setPayment(paymentCondition: v),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ---- Autres termes ----
                      TextFormField(
                        controller: terms,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Other Terms (optional)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => context.read<TransportRequestProvider>().setPayment(terms: v),
                      ),

                      const SizedBox(height: 200),

                      // ---- Footer ----
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
