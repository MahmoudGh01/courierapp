import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/entry_field.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class AddMoneyPage extends StatefulWidget {
  const AddMoneyPage({super.key});

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  int? selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.addMoney),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 28),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(40),
          ),
          color: kWhiteColor,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              children: [
                EntryField(
                  label: locale.enterAmountToAdd,
                  initialValue: '\$ 100',
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  color: theme.colorScheme.surface,
                  child: Row(
                    children: [
                      Text(
                        locale.choosePaymentMode,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                buildPaymentMethod(
                  theme,
                  0,
                  locale.paypal,
                  locale.payFromPaypalAccount,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 6,
                  color: theme.colorScheme.surface,
                ),
                const SizedBox(height: 10),
                buildPaymentMethod(
                  theme,
                  1,
                  locale.stripe,
                  locale.payFromStripeAccount,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 500,
                  color: theme.colorScheme.surface,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: locale.submitText,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    radius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row buildPaymentMethod(
    ThemeData theme,
    int value,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Radio(
          value: value,
          groupValue: selectedIndex,
          activeColor: theme.primaryColor,
          onChanged: (val) {
            setState(() {
              selectedIndex = val;
            });
          },
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
