import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class SlideUpPanel extends StatefulWidget {
  const SlideUpPanel({super.key});

  @override
  State<SlideUpPanel> createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<SlideUpPanel> {
  final listviewController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return DraggableScrollableSheet(
      //minChildSize: 0.25,
      //initialChildSize: 0.5,
      // maxChildSize: 0.975,
      builder: (context, controller) {
        var boxDecoration = BoxDecoration(
          boxShadow: [boxShadow],
          color: kWhiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(35.0)),
        );
        return ListView(
          controller: listviewController,
          padding: const EdgeInsets.symmetric(horizontal: 6.7),
          // physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  boxShadow: [boxShadow],
                  color: kWhiteColor,
                  borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                ),
                child: ListTile(
                  leading: FadedScaleAnimation(
                    child: const CircleAvatar(
                      radius: 25.0,
                      backgroundImage: AssetImage('images/deliveryman.png'),
                    ),
                  ),
                  title: Text(
                    'James Haydon',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: theme.primaryColorDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                  ),
                  subtitle: Text(
                    locale.deliveryMan,
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: theme.hintColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  trailing: FadedScaleAnimation(
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: kMainColor,
                      child: Icon(
                        Icons.phone,
                        size: 24,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 10.0),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
                  decoration: boxDecoration,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.location_on,
                            color: kMainColor.withOpacity(0.35)),
                        title: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Emili Williamson',
                              style: theme.textTheme.titleLarge!.copyWith(
                                color: theme.primaryColorDark,
                                height: 1.5,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                        ),
                        subtitle: Text(
                          '128 Mott St, New York, NY 10013, United States',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      ListTile(
                        leading: Icon(Icons.navigation,
                            color: kMainColor.withOpacity(0.35)),
                        title: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Samantha Smith',
                                style: theme.textTheme.titleLarge!.copyWith(
                                  color: theme.primaryColorDark,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ))
                          ]),
                        ),
                        subtitle: Text(
                          '2210 St. Merry Church, New York, NY 10013, United States',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  top: 12.0,
                  end: 16.0,
                  child: FadedScaleAnimation(
                    child: InkWell(
                      onTap: () {
                        listviewController.animateTo(
                          listviewController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: kMainColor,
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: kWhiteColor,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: boxDecoration,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: '${locale.courierType}\n',
                            style: theme.textTheme.titleSmall!.copyWith(
                                color: theme.hintColor.withOpacity(0.7)),
                          ),
                          TextSpan(
                            text: locale.household,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ]),
                      ),
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${locale.frangible}\n',
                              style: theme.textTheme.titleSmall!.copyWith(
                                color: theme.hintColor.withOpacity(0.7),
                              ),
                            ),
                            TextSpan(
                              text: locale.yes,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${locale.courierInfo}\n',
                        style: theme.textTheme.titleSmall!
                            .copyWith(color: theme.hintColor.withOpacity(0.7)),
                      ),
                      TextSpan(
                        text: locale.comment4,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
                decoration: boxDecoration,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  title: Text(
                    'Delivery Charge',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                  ),
                  subtitle: Text(
                    'Payment via Wallet',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: const Color(0xffc2c2c2),
                          fontSize: 11.7,
                        ),
                  ),
                  trailing: Text(
                    '\$8.60',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: theme.primaryColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                )),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
