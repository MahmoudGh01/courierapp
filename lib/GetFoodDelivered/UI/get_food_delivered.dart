import 'package:courier_app/Components/address_field.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Components/map_widget.dart';
import 'package:courier_app/GetFoodDelivered/UI/foodconfirm_info.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class GetFoodDeliveredPage extends StatelessWidget {
  const GetFoodDeliveredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetFoodDeliveredBody();
  }
}

class GetFoodDeliveredBody extends StatefulWidget {
  const GetFoodDeliveredBody({super.key});

  @override
  State<GetFoodDeliveredBody> createState() => _GetFoodDeliveredBodyState();
}

class _GetFoodDeliveredBodyState extends State<GetFoodDeliveredBody> {
  int currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: currentIndex,
    );
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: mediaQuery.size.height,
          child: Column(
            children: [
              const Spacer(),
              CustomAppBar(
                  title: currentIndex == 0
                      ? locale.pickupLoc
                      : currentIndex == 1
                          ? locale.dropLocation
                          : currentIndex == 2
                              ? locale.foodInfo
                              : locale.confirmInfo),
              const Spacer(),
              SizedBox(
                height: mediaQuery.size.height * 0.85,
                child: Row(
                  children: [
                    SizedBox(
                      width: 68,
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 0;
                              });
                              _pageController!.animateToPage(currentIndex,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linearToEaseOut);
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: currentIndex == 0
                                  ? kWhiteColor
                                  : kNavigationButtonColor,
                              child: Icon(
                                Icons.local_pizza,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 1;
                              });
                              _pageController!.animateToPage(currentIndex,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linearToEaseOut);
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: currentIndex == 1
                                  ? kWhiteColor
                                  : kNavigationButtonColor,
                              child: Icon(
                                Icons.navigation,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 2;
                              });
                              _pageController!.animateToPage(currentIndex,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linearToEaseOut);
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: currentIndex == 2
                                  ? kWhiteColor
                                  : kNavigationButtonColor,
                              child: Icon(
                                Icons.restaurant_menu,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 3;
                              });
                              _pageController!.animateToPage(currentIndex,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linearToEaseOut);
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: currentIndex == 3
                                  ? kWhiteColor
                                  : kNavigationButtonColor,
                              child: Icon(
                                Icons.assignment,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        physics: const BouncingScrollPhysics(),
                        controller: _pageController,
                        scrollDirection: Axis.vertical,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        children: [
                          buildPage(theme, locale, locale.pickup),
                          buildPage(theme, locale, locale.drop),
                          foodInfo(theme, locale),
                          const FoodConfirmInfo(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage(ThemeData theme, AppLocalizations locale, String pickup) {
    return MapWidget(
      child: pickup == locale.pickup
          ? Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(boxShadow: [boxShadow]),
                  margin: const EdgeInsets.all(16.0),
                  child: AddressField(
                    hint: locale.searchRes,
                    icon: Icon(Icons.local_pizza, color: theme.primaryColor),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: kButtonColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12.0),
                  child: ListTile(
                    leading: Icon(Icons.location_on, color: kMainColor),
                    title: Text(
                      '128 Mott St, New York, NY 10013, United States',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                Container(
                  color: kWhiteColor,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AddressField(
                        icon:
                            Icon(Icons.local_pizza, color: theme.primaryColor),
                        color: kButtonColor,
                        hint: locale.nameRes,
                        readOnly: true,
                      ),
                      AddressField(
                        icon: Icon(Icons.phone, color: theme.primaryColor),
                        color: kButtonColor,
                        hint: locale.contactNumber,
                        readOnly: true,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 180, top: 20),
                        child: CustomButton(
                          text: '${locale.continueText}  ↓',
                          radius: BorderRadius.circular(35.0),
                          padding: 10,
                          onPressed: () {
                            setState(() {
                              currentIndex = 1;
                            });
                            _pageController!.animateToPage(currentIndex,
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.linearToEaseOut);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(boxShadow: [boxShadow]),
                  margin: const EdgeInsets.all(16.0),
                  child: AddressField(
                    hint: locale.dropHint,
                    icon: Icon(Icons.navigation, color: theme.primaryColor),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: kButtonColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12.0),
                  child: ListTile(
                    leading: Icon(Icons.navigation, color: theme.primaryColor),
                    title: Text(
                      'Paris, France',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                Container(
                  color: kWhiteColor,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AddressField(
                        icon: Icon(Icons.assistant, color: theme.primaryColor),
                        color: kButtonColor,
                        hint: locale.nameRes,
                        readOnly: true,
                      ),
                      AddressField(
                        icon: Icon(Icons.person, color: theme.primaryColor),
                        color: kButtonColor,
                        hint: locale.namePerson,
                        suffix: Icon(
                          Icons.contacts,
                          color: theme.primaryColor,
                        ),
                        readOnly: true,
                      ),
                      AddressField(
                        icon: Icon(Icons.phone, color: theme.primaryColor),
                        color: kButtonColor,
                        hint: locale.contactNumber,
                        readOnly: true,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 180, top: 20),
                        child: CustomButton(
                          text: '${locale.continueText}  ↓',
                          radius: BorderRadius.circular(35.0),
                          padding: 10,
                          onPressed: () {
                            setState(() {
                              currentIndex = 2;
                            });
                            _pageController!.animateToPage(currentIndex,
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.linearToEaseOut);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget foodInfo(ThemeData theme, AppLocalizations locale) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: borderRadius,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${locale.addFood}\n',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  AddressField(
                    hint: locale.addItem,
                    color: kButtonColor,
                    icon: Icon(
                      Icons.restaurant_menu,
                      color: theme.primaryColor,
                    ),
                    suffix: Text(
                      '\nQtn',
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: theme.hintColor),
                    ),
                  ),
                  AddressField(
                    hint: locale.addItem,
                    color: kButtonColor,
                    icon: Icon(
                      Icons.restaurant_menu,
                      color: theme.primaryColor,
                    ),
                    suffix: Text(
                      '\nQtn',
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: theme.hintColor),
                    ),
                  ),
                  AddressField(
                    hint: locale.addItem,
                    color: kButtonColor,
                    icon: Icon(
                      Icons.restaurant_menu,
                      color: theme.primaryColor,
                    ),
                    suffix: Text(
                      '\nQtn',
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: theme.hintColor),
                    ),
                  ),
                  Text(
                    '\n    + ${locale.addMore}\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: theme.primaryColor),
                  ),
                ],
              ),
            ),
            Divider(thickness: 6, color: kButtonColor),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${locale.addinfo}\n',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: kContainerTextColor),
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: locale.addinfoInput,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: theme.hintColor),
                      filled: true,
                      fillColor: kButtonColor,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Divider(thickness: 6, color: kButtonColor),
            Container(
              color: kButtonColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: kMainColor,
                        size: 12.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          locale.availableText,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: kMainColor,
                        size: 12.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          locale.delivCall,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: kMainColor,
                        size: 12.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          locale.delivCharges,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 180, top: 20),
                    child: CustomButton(
                      text: '     ${locale.continueText}  ↓     ',
                      radius: BorderRadius.circular(35.0),
                      padding: 10,
                      onPressed: () {
                        setState(() {
                          currentIndex = 3;
                        });
                        _pageController!.animateToPage(currentIndex,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.linearToEaseOut);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
