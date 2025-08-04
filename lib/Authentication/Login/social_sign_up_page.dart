import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Authentication/signin_navigator.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Components/entry_field.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class SocialSignUpPage extends StatelessWidget {
  const SocialSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SocialSignUpBody();
  }
}

class SocialSignUpBody extends StatefulWidget {
  const SocialSignUpBody({super.key});

  @override
  State<SocialSignUpBody> createState() => _SocialSignUpBodyState();
}

class _SocialSignUpBodyState extends State<SocialSignUpBody> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: FadedSlideAnimation(
        beginOffset: const Offset(0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: mediaQuery.size.height,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      const CustomAppBar(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "\n${locale.hey} Samntha Smith",
                          style:
                              Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          '\n${locale.socialText}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const Spacer(flex: 2),
                      Container(
                        height: mediaQuery.size.height * 0.58,
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: const BorderRadiusDirectional.only(
                            topStart: Radius.circular(35.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Spacer(),
                            EntryField(
                              label: locale.countryText,
                              hint: locale.selectCountryFromList,
                              suffixIcon: Icons.arrow_drop_down,
                              readOnly: true,
                            ),
                            EntryField(
                              label: locale.phoneText,
                              hint: locale.phoneHint,
                              keyboardType: TextInputType.number,
                            ),
                            const Spacer(),
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    width: mediaQuery.size.width,
                    top: mediaQuery.size.height / 3.1,
                    child: const Center(
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage("images/profile.png"),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    bottom: 0,
                    child: CustomButton(
                      radius: const BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                      ),
                      onPressed: () => Navigator.pushNamed(
                          context, SignInRoutes.verification),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
