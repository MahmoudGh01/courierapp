import 'package:courier_app/Authentication/Login/login_page.dart';
import 'package:courier_app/Authentication/Login/social_sign_up_page.dart';
import 'package:courier_app/Authentication/Register/register_page.dart';
import 'package:courier_app/Authentication/Verification/verification_page.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SignInRoutes {
  static const String signInRoot = 'signIn/';
  static const String signUp = 'login/signUp';
  static const String verification = 'login/verification';
  static const String socialLogin = 'login/social_login';
}

class SignInNavigator extends StatelessWidget {
  const SignInNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var canPop = navigatorKey.currentState!.canPop();
        if (canPop) {
          navigatorKey.currentState!.pop();
        }
        return !canPop;
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: SignInRoutes.signInRoot,
        onGenerateRoute: (RouteSettings settings) {
          late WidgetBuilder builder;
          switch (settings.name) {
            case SignInRoutes.signInRoot:
              builder = (BuildContext _) => LoginPage(
                onLoginSuccess: () {
                  Navigator.popAndPushNamed(context, PageRoutes.bottomNavigation);
                },
              );
              break;

            case SignInRoutes.signUp:
              builder = (BuildContext _) => const RegisterPage();
              break;
            case SignInRoutes.verification:
              builder =
                  (BuildContext _) => VerificationPage(onVerificationDone: () {
                        Navigator.popAndPushNamed(
                            context, PageRoutes.bottomNavigation); // Navigate to the main app page
                      });
              break;
            case SignInRoutes.socialLogin:
              builder = (BuildContext _) => const SocialSignUpPage();
              break;
            // Fallback page
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
        onPopPage: (Route<dynamic> route, dynamic result) {
          return route.didPop(result);
        },
      ),
    );
  }
}
