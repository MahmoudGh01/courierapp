import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Components/entry_field.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatelessWidget {
  final VoidCallback? onVerificationDone;
  const VerificationPage({super.key, this.onVerificationDone});
  @override
  Widget build(BuildContext context) {
    return VerificationBody(onVerificationDone);
  }
}

class VerificationBody extends StatefulWidget {
  final VoidCallback? onVerificationDone;
  const VerificationBody(this.onVerificationDone, {super.key});
  @override
  State<VerificationBody> createState() => _VerificationBodyState();
}

class _VerificationBodyState extends State<VerificationBody> {
  int _counter = 23;
  late Timer _timer;

  _startTimer() {
    //shows timer
    _counter = 23; //time counter

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter > 0 ? _counter-- : _timer.cancel();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  void verifyPhoneNumber() {
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomAppBar(title: locale.verificationText),
                  const Spacer(),
                  Container(
                    height: mediaQuery.size.height * 0.85,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(35.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 28),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            locale.otpText,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 40),
                        EntryField(
                          label: locale.enterOTP,
                          hint: locale.otpText1,
                          maxLength: 6,
                        ),
                        const Spacer(flex: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "0:${_counter.toString().padLeft(2,'0')} min",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600,),
                              ),
                              CustomButton(
                                text: locale.resendText,color: Colors.transparent,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600,),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: locale.submitText,
                          radius: const BorderRadius.only(
                            topRight: Radius.circular(35.0),
                          ),
                          onPressed: () {
                            widget.onVerificationDone!();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
