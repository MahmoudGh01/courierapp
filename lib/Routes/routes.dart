import 'package:courier_app/BottomNavigation/Account/add_money_page.dart';
import 'package:courier_app/BottomNavigation/Account/privacy_policy_page.dart';
import 'package:courier_app/BottomNavigation/Account/wallet_page.dart';
import 'package:courier_app/arrange_delivery/UI/arrange_delivery.dart';
import 'package:courier_app/arrange_delivery/UI/measurement.dart';
import 'package:courier_app/Authentication/signin_navigator.dart';
import 'package:courier_app/BottomNavigation/Account/contact_us_page.dart';
import 'package:courier_app/BottomNavigation/Account/my_profile_page.dart';
import 'package:courier_app/BottomNavigation/Account/saved_address_page.dart';
import 'package:courier_app/BottomNavigation/Account/tnc_page.dart';
import 'package:courier_app/BottomNavigation/MyDeliveries/my_deliveries.dart';
import 'package:courier_app/BottomNavigation/bottom_navigation.dart';
import 'package:courier_app/GetFoodDelivered/UI/get_food_delivered.dart';
import 'package:courier_app/GetGroceryDelivered/UI/get_grocery_delivered.dart';
import 'package:courier_app/Pages/track_delivery.dart';
import 'package:courier_app/Payment/payment.dart';
import 'package:courier_app/Payment/pickup_assigned.dart';
import 'package:courier_app/app_settings/ui/language_sheet.dart';
import 'package:courier_app/transport_request/transport_request_wizard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:courier_app/transport_request/transport_request_wizard.dart';

import '../transport_request/transport_request_wizard.dart';

class PageRoutes {
  static const String trackDelivery = 'track_delivery';
  static const String savedAddressesPage = 'saved_addresses_page';
  static const String contactUsPage = 'contact_us_page';
  static const String tncPage = 'Terms&Condition';
  static const String bottomNavigation = 'bottom_navigation';
  static const String deliverypickupLocation = 'deliverypickup_location';
  static const String deliverydropLocation = 'deliverydrop_location';
  static const String courierInfo = 'courier_info';
  static const String deliveryconfirmInfo = 'deliveryconfirm_info';
  static const String measurement = 'measurement';
  static const String payment = 'payment';
  static const String pickupAssigned = 'pickup_assigned';
  static const String deliveries = 'my_deliveries';
  static const String myProfilePage = 'my_profile_page';
  static const String arrangeDeliveryPage = 'arrange_delivery_page';
  static const String transportRequestWizard = 'transport-request';
  static const String getFoodDeliveredPage = 'get_food_delivered_page';
  static const String getGroceryDeliveredPage = 'get_grocery_delivered_page';
  static const String languagePage = 'language_page';
  static const String signInNavigator = 'signInNavigator';
  static const String walletPage = 'wallet';
  static const String addMoneyPage = 'add_money';
  static const String privacyPolicyPage = 'privacy_policy';

  Map<String, WidgetBuilder> routes() {
    return {
      trackDelivery: (context) => const TrackDelivery(),
      savedAddressesPage: (context) => const SavedAddressesPage(),
      contactUsPage: (context) => const ContactUsPage(),
      tncPage: (context) => const TncPage(),
      deliveries: (context) => const MyDeliveriesPage(),
      bottomNavigation: (context) => const BottomNavigation(),
      measurement: (context) => const Measurement(),
      payment: (context) => const Payment(),
      pickupAssigned: (context) => const PickupAssigned(),
      myProfilePage: (context) => const MyProfilePage(),
      arrangeDeliveryPage: (context) => const ArrangeDeliveryPage(),
      transportRequestWizard: (context) => const TransportRequestWizard(),
      getFoodDeliveredPage: (context) => const GetFoodDeliveredPage(),
      getGroceryDeliveredPage: (context) => const GetGroceryDeliveredPage(),
      languagePage: (context) => const LanguageSheet(),
      signInNavigator: (context) => const SignInNavigator(),
      walletPage: (context) => const WalletPage(),
      addMoneyPage: (context) => const AddMoneyPage(),
      privacyPolicyPage: (context) => const PrivacyPolicyPage(),
    };
  }
}
