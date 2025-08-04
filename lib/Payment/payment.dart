import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class BottomList {
  final String? title;
  final String? subtitle;

  BottomList({this.title, this.subtitle});
}

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int? selectedMode = -1;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    final List<BottomList> paymentMode = <BottomList>[
      BottomList(
        title: locale.cashonPickup,
        subtitle: locale.payWhilePickDelivery,
      ),
      BottomList(
        title: locale.cashonDelivery,
        subtitle: locale.paywhileDropDelivery,
      ),
      BottomList(
        title: locale.payPal,
        subtitle: locale.payPayPalAccount,
      ),
      BottomList(
        title: locale.stripe,
        subtitle: locale.payStripeAccount,
      )
    ];
    var theme = Theme.of(context);
    return FadedSlideAnimation(
      beginOffset: const Offset(0, 0.3),
      endOffset: const Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: AppBar(
              leading: GestureDetector(
                child: const Icon(Icons.arrow_back_ios),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                locale.payment,
                style: theme.textTheme.headlineSmall,
              ),
              backgroundColor: kMainColor,
            ),
          ),
        ),
        body: ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            decoration: BoxDecoration(
              color: kButtonColor,
              borderRadius: borderRadius,
            ),
            child: Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 40.0,
                        bottom: 40.0,
                        right: 20.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              locale.deliveryCharges,
                              style: theme.textTheme.titleLarge!.copyWith(
                                color: theme.primaryColorDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            '\$ 8.60',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      color: theme.colorScheme.surface,
                      child: Text(
                        locale.choosePaymentMode,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentMode.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          activeColor: Theme.of(context).primaryColor,
                          value: index,
                          groupValue: selectedMode,
                          title: Text(
                            paymentMode[index].title!,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                    ),
                          ),
                          subtitle: Text(
                            paymentMode[index].subtitle!,
                            style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 13.3, color: const Color(0xffc1c1c1)),
                          ),
                          onChanged: (dynamic value) {
                            selectedMode = value;

                            setState(() {});
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 5,
                          thickness: 5,
                          color: theme.colorScheme.surface,
                        );
                      },
                    ),
                    Divider(
                      height: 250,
                      thickness: 250,
                      color: theme.colorScheme.surface,
                    ),
                  ],
                ),
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  bottom: 0.0,
                  child: CustomButton(
                    text: locale.continueText,
                    radius: const BorderRadius.only(
                        topRight: Radius.circular(35.0)),
                    onPressed: () =>
                        Navigator.pushNamed(context, PageRoutes.pickupAssigned),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
