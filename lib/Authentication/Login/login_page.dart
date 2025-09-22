import 'dart:async';
import 'dart:convert';
import 'dart:developer' as Log;
import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Authentication/signin_navigator.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/entry_field.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/app_config/app_config.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:courier_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../Service/Auth.dart';


class LoginPage extends StatelessWidget {
  final VoidCallback onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return LoginBody(onLoginSuccess: onLoginSuccess);
  }
}

class LoginBody extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginBody({super.key, required this.onLoginSuccess});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final AuthService authService = AuthService();
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    final GoogleSignIn signIn = GoogleSignIn.instance;
    unawaited(
        signIn.initialize(clientId: Constants.Android));
    /* WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        showModalBottomSheet(
          context: context,
          builder: (context) => const LanguageSheet(),
        );
      },
    );*/
  }


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  void loginUser() {
    authService.signInUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
      onLoginSuccess: widget.onLoginSuccess, // <<< pass it here
    );
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: FadedSlideAnimation(
        beginOffset: const Offset(0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: SafeArea(
          child: Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    AppConfig.appName,
                    style:
                        theme.textTheme.headlineSmall?.copyWith(fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: mediaQuery.size.height * 0.9,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(35.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 32.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            locale.signIn,
                            style: theme.textTheme.headlineSmall!.copyWith(
                              color: theme.scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50.0),
                        EntryField(
                          controller: emailController,
                          label: locale.emailText,
                          hint: locale.emailHint,
                        ),
                        EntryField(
                          controller: passwordController,
                          label: locale.passwordText,
                          hint: locale.passwordHint,
                          isPassword: true,
                        ),
                        const SizedBox(height: 16.0),
                        CustomButton(
                          radius: const BorderRadius.only(
                            topRight: Radius.circular(35.0),
                          ),
                          onPressed: () => loginUser(),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignInRoutes.signUp);
                          },
                          child: Text(
                            '\n${locale.signUp}',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        GestureDetector(
                          onTap: () async {
                            try {
                              await signInWithGoogle();
                            } catch (e) {
                              print(e.toString());
                              Log.log(e.toString());
                              // TODO
                            }
                          },
                          child: Text(
                            "locale.googleSignIn",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 50.0),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // optional: force account picker
      final GoogleSignInAccount? googleUser = await _googleSignIn.attemptLightweightAuthentication();
      if (googleUser == null) return; // user canceled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      if (idToken != null) {
        await authService.sendGoogleSignInDataToBackend(idToken, context);
        widget.onLoginSuccess();
      }
    } catch (e) {
      print("Google sign-in failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed: $e")),
      );
    }
  }


}
