import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Components/entry_field.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyProfileBody();
  }
}

class MyProfileBody extends StatefulWidget {
  const MyProfileBody({super.key});

  @override
  State<MyProfileBody> createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody> {
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
              height: mediaQuery.size.height - mediaQuery.padding.vertical,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      CustomAppBar(
                        title: locale.myProfile,
                      ),
                      const Spacer(flex: 2),
                      Container(
                        height: mediaQuery.size.height * 0.78,
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
                              label: locale.fullName,
                              initialValue: 'Samantha Smith',
                              readOnly: true,
                            ),
                            EntryField(
                              label: locale.emailText,
                              initialValue: 'samanthasmith@gmail.com',
                              readOnly: true,
                            ),
                            EntryField(
                              label: locale.phoneText,
                              initialValue: '+1 9876543210',
                              readOnly: true,
                            ),
                            const Spacer(flex: 2),
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    width: mediaQuery.size.width,
                    top: mediaQuery.size.height * 0.14,
                    child: Center(
                      child: FadedScaleAnimation(
                        child: const CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage("images/profile.png"),
                        ),
                      ),
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
