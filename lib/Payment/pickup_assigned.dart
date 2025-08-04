import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class PickupAssigned extends StatefulWidget {
  const PickupAssigned({super.key});

  @override
  State<PickupAssigned> createState() => _PickupAssignedState();
}

class _PickupAssignedState extends State<PickupAssigned> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return FadedSlideAnimation(
      beginOffset: const Offset(0, 0.3),
      endOffset: const Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kMainColor,
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
                locale.pickupAssigned,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(),
              Expanded(
                flex: 10,
                child: FadedScaleAnimation(
                  child: Image.asset(
                    'images/pickup.png',
                    scale: 3,
                  ),
                ),
              ),
              Text(
                locale.pickupArranged,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 3,
                    child: Text(
                      locale.thanksText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: const Color(0xff9d9db5),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const Spacer(flex: 4),
              CustomButton(
                text: locale.trackCourier,
                radius:
                    const BorderRadius.only(topRight: Radius.circular(35.0)),
                onPressed: () => Navigator.popAndPushNamed(
                    context, PageRoutes.bottomNavigation),
              )
            ],
          ),
        ),
      ),
    );
  }
}
