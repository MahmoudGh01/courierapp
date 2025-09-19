import 'package:courier_app/Theme/colors.dart';
import 'package:flutter/material.dart';

//app theme
final ThemeData appTheme = ThemeData(
  fontFamily: 'ProductSans',
  scaffoldBackgroundColor: kMainColor,
  primaryColor: kMainColor,
  disabledColor: kDisabledColor,
  buttonTheme: ButtonThemeData(buttonColor: kMainColor),
  indicatorColor: kMainColor,
  hintColor: kHintColor,
  dividerColor: const Color(0xffc2c2c2),
  primaryColorDark: kMainTextColor,
  hoverColor: kLightTextColor,
  cardColor: const Color(0xffeaeaea),
  bottomAppBarTheme: BottomAppBarThemeData(color: kMainColor),
  appBarTheme: AppBarTheme(
    color: kTransparentColor,
    elevation: 0.0,
    iconTheme: IconThemeData(color: kWhiteColor),
    centerTitle: true,
  ),

  //text theme which contains all text styles
  textTheme: TextTheme(
    //default text style of Text Widget
    bodyLarge: const TextStyle(),
    bodyMedium: const TextStyle(),
    titleMedium: TextStyle(color: kButtonTextColor),
    titleSmall: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(
        fontWeight: FontWeight.w500, color: kWhiteColor, fontSize: 22),
    titleLarge: TextStyle(color: kLightTextColor),
    bodySmall: TextStyle(color: kMainTextColor),
    labelLarge: TextStyle(fontSize: 16, color: kWhiteColor),
  ),
  colorScheme: ColorScheme.light(secondary: kTransparentColor).copyWith(
    background: const Color(0xfff4f4f6),
  ),
);

BoxShadow boxShadow = BoxShadow(
  color: kContainerShadowColor,
  blurRadius: 19.4, // soften the shadow
  spreadRadius: 1.2, //extend the shadow
  offset: const Offset(
    0.0, // Move to right 10  horizontally
    10.3, // Move to bottom 10 Vertically
  ),
);

BorderRadius borderRadius =
    const BorderRadius.only(topLeft: Radius.circular(35.0));

/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
