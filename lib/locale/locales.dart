import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

import 'Languages/arabic.dart';
import 'Languages/french.dart';
import 'Languages/german.dart';
import 'Languages/indonesian.dart';
import 'Languages/italian.dart';
import 'Languages/portuguese.dart';
import 'Languages/romanian.dart';
import 'Languages/spanish.dart';
import 'Languages/swahili.dart';
import 'Languages/turkish.dart';
import 'languages/english.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': english(),
    'ar': arabic(),
    'pt': portuguese(),
    'fr': french(),
    'id': indonesian(),
    'es': spanish(),
    'it': italian(),
    'tr': turkish(),
    'sw': swahili(),
    'ro': romanian(),
    'de': german(),
  };

  String get signIn {
    return _localizedValues[locale.languageCode]!['signIn'] ?? '';
  }
  String get saved {
    return _localizedValues[locale.languageCode]!['saved'] ?? '';
  }
  String get registerAsCompany {
    return _localizedValues[locale.languageCode]!['registerAsCompany'] ?? '';
  }
  String get companyName {
    return _localizedValues[locale.languageCode]!['companyName'] ?? '';
  }
  String get companyRegistrationNumber {
    return _localizedValues[locale.languageCode]!['companyRegistrationNumber'] ?? '';
  }
  String get signUp {
    return _localizedValues[locale.languageCode]!['signUp'] ?? '';
  }
  String get countryText {
    return _localizedValues[locale.languageCode]!['countryText'] ?? '';
  }

  String get passwordText {
    return _localizedValues[locale.languageCode]!['passwordText'] ?? '';
  }
  String get passwordHint {
    return _localizedValues[locale.languageCode]!['passwordHint'] ?? '';
  }
  String get phoneText {
    return _localizedValues[locale.languageCode]!['phoneText'] ?? '';
  }

  String get phoneHint {
    return _localizedValues[locale.languageCode]!['phoneHint'] ?? '';
  }

  String get continueText {
    return _localizedValues[locale.languageCode]!['continueText'] ?? '';
  }

  String get signinOTP {
    return _localizedValues[locale.languageCode]!['signinOTP'] ?? '';
  }

  String get orContinue {
    return _localizedValues[locale.languageCode]!['orContinue'] ?? '';
  }

  String get facebook {
    return _localizedValues[locale.languageCode]!['facebook'] ?? '';
  }

  String get google {
    return _localizedValues[locale.languageCode]!['google'] ?? '';
  }

  String get apple {
    return _localizedValues[locale.languageCode]!['apple'] ?? '';
  }

  String get networkError {
    return _localizedValues[locale.languageCode]!['networkError'] ?? '';
  }

  String get invalidNumber {
    return _localizedValues[locale.languageCode]!['invalidNumber'] ?? '';
  }

  String get invalidName {
    return _localizedValues[locale.languageCode]!['invalidName'] ?? '';
  }

  String get invalidEmail {
    return _localizedValues[locale.languageCode]!['invalidEmail'] ?? '';
  }

  String get invalidOTP {
    return _localizedValues[locale.languageCode]!['invalidOTP'] ?? '';
  }

  String get otpText {
    return _localizedValues[locale.languageCode]!['otpText'] ?? '';
  }

  String get otpText1 {
    return _localizedValues[locale.languageCode]!['otpText1'] ?? '';
  }

  String get resendText {
    return _localizedValues[locale.languageCode]!['resendText'] ?? '';
  }

  String get enterOTP {
    return _localizedValues[locale.languageCode]!['enterOTP'] ?? '';
  }

  String get invalidNameEmail {
    return _localizedValues[locale.languageCode]!['invalidNameEmail'] ?? '';
  }

  String get nameText {
    return _localizedValues[locale.languageCode]!['nameText'] ?? '';
  }

  String get nameHint {
    return _localizedValues[locale.languageCode]!['nameHint'] ?? '';
  }

  String get emailText {
    return _localizedValues[locale.languageCode]!['emailText'] ?? '';
  }

  String get emailHint {
    return _localizedValues[locale.languageCode]!['emailHint'] ?? '';
  }

  String get submitText {
    return _localizedValues[locale.languageCode]!['submitText'] ?? '';
  }

  String get verificationText {
    return _localizedValues[locale.languageCode]!['verificationText'] ?? '';
  }

  String get checkPhoneNetwork {
    return _localizedValues[locale.languageCode]!['checkPhoneNetwork'] ?? '';
  }

  String get signinfailed {
    return _localizedValues[locale.languageCode]!['signinfailed'] ?? '';
  }

  String get socialText {
    return _localizedValues[locale.languageCode]!['socialText'] ?? '';
  }

  String get registerText {
    return _localizedValues[locale.languageCode]!['registerText'] ?? '';
  }

  String get homeText {
    return _localizedValues[locale.languageCode]!['homeText'] ?? '';
  }

  String get accountText {
    return _localizedValues[locale.languageCode]!['accountText'] ?? '';
  }

  String get myDeliv {
    return _localizedValues[locale.languageCode]!['myDeliv'] ?? '';
  }

  String get pendingDeliv {
    return _localizedValues[locale.languageCode]!['pendingDeliv'] ?? '';
  }

  String get pastDeliv {
    return _localizedValues[locale.languageCode]!['pastDeliv'] ?? '';
  }

  String get grocery {
    return _localizedValues[locale.languageCode]!['grocery'] ?? '';
  }

  String get delivered {
    return _localizedValues[locale.languageCode]!['delivered'] ?? '';
  }

  String get myAccount {
    return _localizedValues[locale.languageCode]!['myAccount'] ?? '';
  }

  String get foodText {
    return _localizedValues[locale.languageCode]!['foodText'] ?? '';
  }

  String get savedAddresses {
    return _localizedValues[locale.languageCode]!['savedAddresses'] ?? '';
  }

  String get saveAddress {
    return _localizedValues[locale.languageCode]!['saveAddress'] ?? '';
  }

  String get tnc {
    return _localizedValues[locale.languageCode]!['tnc'] ?? '';
  }

  String get knowtnc {
    return _localizedValues[locale.languageCode]!['knowtnc'] ?? '';
  }

  String get shareApp {
    return _localizedValues[locale.languageCode]!['shareApp'] ?? '';
  }

  String get shareFriends {
    return _localizedValues[locale.languageCode]!['shareFriends'] ?? '';
  }

  String get support {
    return _localizedValues[locale.languageCode]!['support'] ?? '';
  }

  String get aboutUs {
    return _localizedValues[locale.languageCode]!['aboutUs'] ?? '';
  }

  String get recentSearch {
    return _localizedValues[locale.languageCode]!['recentSearch'] ?? '';
  }

  String get contactUs {
    return _localizedValues[locale.languageCode]!['contactUs'] ?? '';
  }

  String get contactQuery {
    return _localizedValues[locale.languageCode]!['contactQuery'] ?? '';
  }

  String get feedbackText {
    return _localizedValues[locale.languageCode]!['feedbackText'] ?? '';
  }

  String get yourMessage {
    return _localizedValues[locale.languageCode]!['yourMessage'] ?? '';
  }

  String get entermsg {
    return _localizedValues[locale.languageCode]!['entermsg'] ?? '';
  }

  String get sendmsg {
    return _localizedValues[locale.languageCode]!['sendmsg'] ?? '';
  }

  String get foodInfo {
    return _localizedValues[locale.languageCode]!['foodInfo'] ?? '';
  }

  String get addFood {
    return _localizedValues[locale.languageCode]!['addFood'] ?? '';
  }

  String get addGrocery {
    return _localizedValues[locale.languageCode]!['addGrocery'] ?? '';
  }

  String get addItem {
    return _localizedValues[locale.languageCode]!['addItem'] ?? '';
  }

  String get addMore {
    return _localizedValues[locale.languageCode]!['addMore'] ?? '';
  }

  String get addinfo {
    return _localizedValues[locale.languageCode]!['addinfo'] ?? '';
  }

  String get addinfoInput {
    return _localizedValues[locale.languageCode]!['addinfoInput'] ?? '';
  }

  String get addFresh {
    return _localizedValues[locale.languageCode]!['addFresh'] ?? '';
  }

  String get groceryStore {
    return _localizedValues[locale.languageCode]!['groceryStore'] ?? '';
  }

  String get availableText {
    return _localizedValues[locale.languageCode]!['availableText'] ?? '';
  }

  String get delivCall {
    return _localizedValues[locale.languageCode]!['delivCall'] ?? '';
  }

  String get delivCharges {
    return _localizedValues[locale.languageCode]!['delivCharges'] ?? '';
  }

  String get viewProfile {
    return _localizedValues[locale.languageCode]!['viewProfile'] ?? '';
  }

  String get myProfile {
    return _localizedValues[locale.languageCode]!['myProfile'] ?? '';
  }

  String get logout {
    return _localizedValues[locale.languageCode]!['logout'] ?? '';
  }

  String get loggingout {
    return _localizedValues[locale.languageCode]!['loggingout'] ?? '';
  }

  String get sureText {
    return _localizedValues[locale.languageCode]!['sureText'] ?? '';
  }

  String get no {
    return _localizedValues[locale.languageCode]!['no'] ?? '';
  }

  String get yes {
    return _localizedValues[locale.languageCode]!['yes'] ?? '';
  }

  String get courierInfo {
    return _localizedValues[locale.languageCode]!['courierInfo'] ?? '';
  }

  String get delivInfo {
    return _localizedValues[locale.languageCode]!['delivInfo'] ?? '';
  }

  String get courierInput {
    return _localizedValues[locale.languageCode]!['courierInput'] ?? '';
  }

  String get courierDetail {
    return _localizedValues[locale.languageCode]!['courierDetail'] ?? '';
  }

  String get proceedPayment {
    return _localizedValues[locale.languageCode]!['proceedPayment'] ?? '';
  }

  String get confirmInfo {
    return _localizedValues[locale.languageCode]!['confirmInfo'] ?? '';
  }

  String get distance {
    return _localizedValues[locale.languageCode]!['distance'] ?? '';
  }

  String get searchRes {
    return _localizedValues[locale.languageCode]!['searchRes'] ?? '';
  }

  String get searchStore {
    return _localizedValues[locale.languageCode]!['searchStore'] ?? '';
  }

  String get nameRes {
    return _localizedValues[locale.languageCode]!['nameRes'] ?? '';
  }

  String get nameStore {
    return _localizedValues[locale.languageCode]!['nameStore'] ?? '';
  }

  String get groceryItem {
    return _localizedValues[locale.languageCode]!['groceryItem'] ?? '';
  }

  String get viewMap {
    return _localizedValues[locale.languageCode]!['viewMap'] ?? '';
  }

  String get ecoTime {
    return _localizedValues[locale.languageCode]!['ecoTime'] ?? '';
  }

  String get contactNumber {
    return _localizedValues[locale.languageCode]!['contactNumber'] ?? '';
  }

  String get dropLocation {
    return _localizedValues[locale.languageCode]!['dropLocation'] ?? '';
  }

  String get dropHint {
    return _localizedValues[locale.languageCode]!['dropHint'] ?? '';
  }

  String get landmark {
    return _localizedValues[locale.languageCode]!['landmark'] ?? '';
  }

  String get measurement {
    return _localizedValues[locale.languageCode]!['measurement'] ?? '';
  }

  String get namePerson {
    return _localizedValues[locale.languageCode]!['namePerson'] ?? '';
  }

  String get paymentMode {
    return _localizedValues[locale.languageCode]!['paymentMode'] ?? '';
  }

  String get restaurant {
    return _localizedValues[locale.languageCode]!['restaurant'] ?? '';
  }

  String get foodItems {
    return _localizedValues[locale.languageCode]!['foodItems'] ?? '';
  }

  String get done {
    return _localizedValues[locale.languageCode]!['done'] ?? '';
  }

  String get amountPay {
    return _localizedValues[locale.languageCode]!['amountPay'] ?? '';
  }

  String get pickupAssigned {
    return _localizedValues[locale.languageCode]!['pickupAssigned'] ?? '';
  }

  String get pickupArranged {
    return _localizedValues[locale.languageCode]!['pickupArranged'] ?? '';
  }

  String get thanksText {
    return _localizedValues[locale.languageCode]!['thanksText'] ?? '';
  }

  String get trackCourier {
    return _localizedValues[locale.languageCode]!['trackCourier'] ?? '';
  }

  String get pickupLoc {
    return _localizedValues[locale.languageCode]!['pickupLoc'] ?? '';
  }

  String get pickupHint {
    return _localizedValues[locale.languageCode]!['pickupHint'] ?? '';
  }

  String get courierType {
    return _localizedValues[locale.languageCode]!['courierType'] ?? '';
  }

  String get envelope {
    return _localizedValues[locale.languageCode]!['envelope'] ?? '';
  }

  String get arrangeDeliv {
    return _localizedValues[locale.languageCode]!['arrangeDeliv'] ?? '';
  }

  String get arrangeDelivText {
    return _localizedValues[locale.languageCode]!['arrangeDelivText'] ?? '';
  }

  String get getFood {
    return _localizedValues[locale.languageCode]!['getFood'] ?? '';
  }

  String get getFoodText {
    return _localizedValues[locale.languageCode]!['getFoodText'] ?? '';
  }

  String get getGrocery {
    return _localizedValues[locale.languageCode]!['getGrocery'] ?? '';
  }

  String get getGroceryText {
    return _localizedValues[locale.languageCode]!['getGroceryText'] ?? '';
  }

  String get promo {
    return _localizedValues[locale.languageCode]!['promo'] ?? '';
  }

  String get courier {
    return _localizedValues[locale.languageCode]!['courier'] ?? '';
  }

  String get boxPack {
    return _localizedValues[locale.languageCode]!['boxPack'] ?? '';
  }

  String get other {
    return _localizedValues[locale.languageCode]!['other'] ?? '';
  }

  String get height {
    return _localizedValues[locale.languageCode]!['height'] ?? '';
  }

  String get width {
    return _localizedValues[locale.languageCode]!['width'] ?? '';
  }

  String get length {
    return _localizedValues[locale.languageCode]!['length'] ?? '';
  }

  String get weight {
    return _localizedValues[locale.languageCode]!['weight'] ?? '';
  }

  String get update {
    return _localizedValues[locale.languageCode]!['update'] ?? '';
  }

  String get selectDelivery {
    return _localizedValues[locale.languageCode]!['selectDelivery'] ?? '';
  }

  String get ecoDelivery {
    return _localizedValues[locale.languageCode]!['ecoDelivery'] ?? '';
  }

  String get delivMode {
    return _localizedValues[locale.languageCode]!['delivMode'] ?? '';
  }

  String get signoutAccount {
    return _localizedValues[locale.languageCode]!['signoutAccount'] ?? '';
  }

  String get selectCountryFromList {
    return _localizedValues[locale.languageCode]!['selectCountryFromList'] ??
        '';
  }

  String get cm {
    return _localizedValues[locale.languageCode]!['cm'] ?? '';
  }

  String get kg {
    return _localizedValues[locale.languageCode]!['kg'] ?? '';
  }

  String get frangible {
    return _localizedValues[locale.languageCode]!['frangible'] ?? '';
  }

  String get economyDelivery {
    return _localizedValues[locale.languageCode]!['economyDelivery'] ?? '';
  }

  String get comment1 {
    return _localizedValues[locale.languageCode]!['comment1'] ?? '';
  }

  String get deluxDelivery {
    return _localizedValues[locale.languageCode]!['deluxDelivery'] ?? '';
  }

  String get comment2 {
    return _localizedValues[locale.languageCode]!['comment2'] ?? '';
  }

  String get premiumDelivery {
    return _localizedValues[locale.languageCode]!['premiumDelivery'] ?? '';
  }

  String get comment3 {
    return _localizedValues[locale.languageCode]!['comment3'] ?? '';
  }

  String get cityGarden {
    return _localizedValues[locale.languageCode]!['cityGarden'] ?? '';
  }

  String get km {
    return _localizedValues[locale.languageCode]!['km'] ?? '';
  }

  String get boxCourier {
    return _localizedValues[locale.languageCode]!['boxCourier'] ?? '';
  }

  String get comment4 {
    return _localizedValues[locale.languageCode]!['comment4'] ?? '';
  }

  String get cashonPickup {
    return _localizedValues[locale.languageCode]!['cashonPickup'] ?? '';
  }

  String get payWhilePickDelivery {
    return _localizedValues[locale.languageCode]!['payWhilePickDelivery'] ?? '';
  }

  String get cashonDelivery {
    return _localizedValues[locale.languageCode]!['cashonDelivery'] ?? '';
  }

  String get paywhileDropDelivery {
    return _localizedValues[locale.languageCode]!['paywhileDropDelivery'] ?? '';
  }

  String get payPal {
    return _localizedValues[locale.languageCode]!['payPal'] ?? '';
  }

  String get payPayPalAccount {
    return _localizedValues[locale.languageCode]!['payPayPalAccount'] ?? '';
  }

  String get stripe {
    return _localizedValues[locale.languageCode]!['stripe'] ?? '';
  }

  String get payStripeAccount {
    return _localizedValues[locale.languageCode]!['payStripeAccount'] ?? '';
  }

  String get usuallyDeliveryin1hour {
    return _localizedValues[locale.languageCode]!['usuallyDeliveryin1hour'] ??
        '';
  }

  String get assured45minutesDelivery {
    return _localizedValues[locale.languageCode]!['assured45minutesDelivery'] ??
        '';
  }

  String get dedicatedDeliveryBoyDeliverin2530minutes {
    return _localizedValues[locale.languageCode]![
            'dedicatedDeliveryBoyDeliverin2530minutes'] ??
        '';
  }

  String get packofEverydayMilk {
    return _localizedValues[locale.languageCode]!['packofEverydayMilk'] ?? '';
  }

  String get frozenChickenPack {
    return _localizedValues[locale.languageCode]!['frozenChickenPack'] ?? '';
  }

  String get coconutOil500 {
    return _localizedValues[locale.languageCode]!['coconutOil500'] ?? '';
  }

  String get keepFrozenChicken {
    return _localizedValues[locale.languageCode]!['keepFrozenChicken'] ?? '';
  }

  String get orderFromUs20Discounts {
    return _localizedValues[locale.languageCode]!['orderFromUs20Discounts'] ??
        '';
  }

  String get orderFromUsWepaydeliveryCharge {
    return _localizedValues[locale.languageCode]![
            'orderFromUsWepaydeliveryCharge'] ??
        '';
  }

  String get cityGroceryStore {
    return _localizedValues[locale.languageCode]!['cityGroceryStore'] ?? '';
  }

  String get wayToDeliver {
    return _localizedValues[locale.languageCode]!['wayToDeliver'] ?? '';
  }

  String get office {
    return _localizedValues[locale.languageCode]!['office'] ?? '';
  }

  String get deliveryMan {
    return _localizedValues[locale.languageCode]!['deliveryMan'] ?? '';
  }

  String get paymentViaCashonPickup {
    return _localizedValues[locale.languageCode]!['paymentViaCashonPickup'] ??
        '';
  }

  String get companyPrivacyPolicy {
    return _localizedValues[locale.languageCode]!['companyPrivacyPolicy'] ?? '';
  }

  String get hey {
    return _localizedValues[locale.languageCode]!['hey'] ?? '';
  }

  String get makelessSpicyWithLessgravy {
    return _localizedValues[locale.languageCode]![
            'makelessSpicyWithLessgravy'] ??
        '';
  }

  String get fullName {
    return _localizedValues[locale.languageCode]!['fullName'] ?? '';
  }

  String get enterFullName {
    return _localizedValues[locale.languageCode]!['enterFullName'] ?? '';
  }

  String get enterLandmark {
    return _localizedValues[locale.languageCode]!['enterLandmark'] ?? '';
  }

  String get saveAddress2 {
    return _localizedValues[locale.languageCode]!['saveAddress2'] ?? '';
  }

  String get heightWidthLength {
    return _localizedValues[locale.languageCode]!['heightWidthLength'] ?? '';
  }

  String get vegSandwich {
    return _localizedValues[locale.languageCode]!['vegSandwich'] ?? '';
  }

  String get farmPizza {
    return _localizedValues[locale.languageCode]!['farmPizza'] ?? '';
  }

  String get chickenSoup {
    return _localizedValues[locale.languageCode]!['chickenSoup'] ?? '';
  }

  String get changeLanguage {
    return _localizedValues[locale.languageCode]!['changeLanguage'] ?? '';
  }

  String get household {
    return _localizedValues[locale.languageCode]!['household'] ?? '';
  }

  String get electronics {
    return _localizedValues[locale.languageCode]!['electronics'] ?? '';
  }

  String get clothes {
    return _localizedValues[locale.languageCode]!['clothes'] ?? '';
  }

  String get paperDocument {
    return _localizedValues[locale.languageCode]!['paperDocument'] ?? '';
  }

  String get flowerChocolate {
    return _localizedValues[locale.languageCode]!['flowerChocolate'] ?? '';
  }

  String get pickup {
    return _localizedValues[locale.languageCode]!['pickup'] ?? '';
  }

  String get drop {
    return _localizedValues[locale.languageCode]!['drop'] ?? '';
  }

  String get deliveryCharge {
    return _localizedValues[locale.languageCode]!['deliveryCharge'] ?? '';
  }

  String get wallet {
    return _localizedValues[locale.languageCode]!['wallet'] ?? '';
  }

  String get yourTransaction {
    return _localizedValues[locale.languageCode]!['yourTransaction'] ?? '';
  }

  String get privacyPolicy {
    return _localizedValues[locale.languageCode]!['privacyPolicy'] ?? '';
  }

  String get companyPrivacyPolicies {
    return _localizedValues[locale.languageCode]!['companyPrivacyPolicies'] ?? '';
  }

  String get addMoney {
    return _localizedValues[locale.languageCode]!['addMoney'] ?? '';
  }

  String get enterAmountToAdd {
    return _localizedValues[locale.languageCode]!['enterAmountToAdd'] ?? '';
  }

  String get choosePaymentMode {
    return _localizedValues[locale.languageCode]!['choosePaymentMode'] ?? '';
  }

  String get paypal {
    return _localizedValues[locale.languageCode]!['paypal'] ?? '';
  }

  String get payFromPaypalAccount {
    return _localizedValues[locale.languageCode]!['payFromPaypalAccount'] ?? '';
  }

  String get payFromStripeAccount {
    return _localizedValues[locale.languageCode]!['payFromStripeAccount'] ?? '';
  }

  String get companyTerms {
    return _localizedValues[locale.languageCode]!['companyTerms'] ?? '';
  }

  String get smallParcel {
    return _localizedValues[locale.languageCode]!['smallParcel'] ?? '';
  }

  String get mediumParcel {
    return _localizedValues[locale.languageCode]!['mediumParcel'] ?? '';
  }

  String get largeParcel {
    return _localizedValues[locale.languageCode]!['largeParcel'] ?? '';
  }

  String get moneyAdded {
    return _localizedValues[locale.languageCode]!['moneyAdded'] ?? '';
  }

  String get balanceAmount {
    return _localizedValues[locale.languageCode]!['balanceAmount'] ?? '';
  }

  String get recentTransactions {
    return _localizedValues[locale.languageCode]!['recentTransactions'] ?? '';
  }

  String get payment {
    return _localizedValues[locale.languageCode]!['payment'] ?? '';
  }

  String get deliveryCharges {
    return _localizedValues[locale.languageCode]!['deliveryCharges'] ?? '';
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        'en',
        'id',
        'pt',
        'ar',
        'fr',
        'es',
        'it',
        'tr',
        'sw',
        'ro',
        'de',
      ].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
