import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';


class ConfirmInfo extends StatefulWidget {
  final String height;
  final String width;
  final String weight;
  final String length;
  final String frangible;

  const ConfirmInfo(
      this.height, this.width, this.weight, this.length, this.frangible,
      {super.key});

  @override
  State<ConfirmInfo> createState() => _ConfirmInfoState();
}

class _ConfirmInfoState extends State<ConfirmInfo> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: borderRadius, color: kWhiteColor),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: kLightTextColor.withOpacity(0.8),
              ),
              title: RichText(
                text: TextSpan(children: [
                  // TextSpan(
                  //   text: 'Walmart' '\n',
                  //   style: theme.textTheme.titleSmall!
                  //       .copyWith(color: theme.hintColor.withOpacity(0.7)),
                  // ),
                  TextSpan(
                      text: 'Emili Williamson',
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.primaryColorDark,
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ))
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
              leading: Icon(
                Icons.navigation,
                color: kLightTextColor.withOpacity(0.8),
              ),
              title: RichText(
                text: TextSpan(children: [
                  // TextSpan(
                  //   text: '${locale.cityGarden}\n',
                  //   style: theme.textTheme.titleSmall!
                  //       .copyWith(color: theme.hintColor.withOpacity(0.7)),
                  // ),
                  TextSpan(
                      text: 'Samantha Smith',
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.primaryColorDark,
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
            const SizedBox(height: 8),
            Divider(color: kButtonColor, thickness: 6),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  locale.distance,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: theme.hintColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                ),
              ),
              subtitle: Row(
                children: <Widget>[
                  Text(
                    '24.2 ${locale.km}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.navigation,
                    color: kLightTextColor.withOpacity(0.8),
                    size: 20,
                  ),
                  Text(
                    locale.viewMap,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: kLightTextColor.withOpacity(0.8),
                        ),
                  )
                ],
              ),
            ),
            Divider(color: kButtonColor, thickness: 6),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${locale.courierType}\n',
                          style: theme.textTheme.titleSmall!.copyWith(
                              color: theme.hintColor.withOpacity(0.7)),
                        ),
                        TextSpan(
                          text: locale.boxCourier,
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${locale.frangible}\n',
                        style: theme.textTheme.titleSmall!
                            .copyWith(color: theme.hintColor.withOpacity(0.7)),
                      ),
                      TextSpan(
                        text: widget.frangible,
                        style:
                            theme.textTheme.bodyLarge!.copyWith(fontSize: 16,
                              fontWeight: FontWeight.w600,

                            ),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Row(
            //     children: [
            //       RichText(
            //         text: TextSpan(children: [
            //           TextSpan(
            //             text:
            //                 '${locale.height} ${locale.width} ${locale.length}\n',
            //             style: theme.textTheme.titleSmall!
            //                 .copyWith(color: theme.hintColor.withOpacity(0.7)),
            //           ),
            //           TextSpan(
            //             text:
            //                 '${widget.height} x ${widget.width} x ${widget.length} (cm)',
            //             style:
            //                 theme.textTheme.bodyLarge!.copyWith(fontSize: 16),
            //           ),
            //         ]),
            //       ),
            //       const Spacer(),
            //       RichText(
            //         text: TextSpan(children: [
            //           TextSpan(
            //             text: '${locale.weight}\n',
            //             style: theme.textTheme.titleSmall!
            //                 .copyWith(color: theme.hintColor.withOpacity(0.7)),
            //           ),
            //           TextSpan(
            //             text: '${widget.weight} kg',
            //             style:
            //                 theme.textTheme.bodyLarge!.copyWith(fontSize: 16),
            //           ),
            //         ]),
            //       ),
            //       const SizedBox(width: 36),
            //     ],
            //   ),
            // ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '${locale.courierInfo}\n',
                    style: theme.textTheme.titleSmall!
                        .copyWith(color: theme.hintColor.withOpacity(0.7)),
                  ),
                  TextSpan(
                    text: locale.comment4,
                    style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16,
                      fontWeight: FontWeight.w600,

                    ),
                  ),
                ]),
              ),
            ),
            Divider(color: kButtonColor, thickness: 6),
            ListTile(
              title: Text(
                locale.deliveryCharge,
                style: theme.textTheme.bodyLarge!.copyWith(fontSize: 16,
                  fontWeight: FontWeight.w600,

                ),
              ),
              trailing: Text('\$8.60',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 18.3,
                    color: theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.w600,
                      )),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  end: 16, start: 120, top: 8, bottom: 20.0),
              child: CustomButton(
                text: locale.proceedPayment,
                radius: BorderRadius.circular(35.0),
                padding: 10,
                onPressed: () =>
                    Navigator.pushNamed(context, PageRoutes.payment),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
