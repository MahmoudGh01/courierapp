import 'package:courier_app/Authentication/signin_navigator.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/app_settings/bloc/language_cubit.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:courier_app/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import 'Authentication/auth_wrapper.dart';
import 'ViewModels/quick_request_provider.dart';
import 'ViewModels/transport_request_provider.dart';
import 'ViewModels/userprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MapUtils.getMarkerPic();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: kTransparentColor,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(
    Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => QuickRequestProvider()),
          ChangeNotifierProvider(create: (_) => TransportRequestProvider()),

        ],
        child: BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit()..getCurrentLanguage(),
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
          Locale('pt'),
          Locale('fr'),
          Locale('id'),
          Locale('es'),
          Locale('it'),
          Locale('tr'),
          Locale('sw'),
          Locale('ro'),
          Locale('de'),
        ],
        home: const AuthWrapper(),   // ⬅️ replace: was SignInNavigator()
        routes: PageRoutes().routes(),
      ),
    );
  }
}
