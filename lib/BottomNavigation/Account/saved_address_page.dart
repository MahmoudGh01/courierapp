import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/address_field.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Components/map_widget.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class SavedAddressesPage extends StatelessWidget {
  const SavedAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SavedAddressesBody();
  }
}

class SavedAddressesBody extends StatefulWidget {
  const SavedAddressesBody({super.key});

  @override
  State<SavedAddressesBody> createState() => _SavedAddressesBodyState();
}

class _SavedAddressesBodyState extends State<SavedAddressesBody> {
  static int _currentIndex = 0;
  final PageController _pageController = PageController(
    initialPage: _currentIndex,
  );

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
        child: SingleChildScrollView(
          child: SizedBox(
            height: mediaQuery.size.height,
            child: Column(
              children: [
                const Spacer(),
                CustomAppBar(title: locale.savedAddresses),
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
                                  _currentIndex = 0;
                                });
                                _pageController.animateToPage(_currentIndex,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.linearToEaseOut);
                              },
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: _currentIndex == 0
                                    ? kWhiteColor
                                    : kNavigationButtonColor,
                                child: Icon(
                                  Icons.home,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _currentIndex = 1;
                                });
                                _pageController.animateToPage(_currentIndex,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.linearToEaseOut);
                              },
                              child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: _currentIndex == 1
                                      ? kWhiteColor
                                      : kNavigationButtonColor,
                                  child: ImageIcon(
                                    const AssetImage('images/ic_officewt.png'),
                                    color: theme.primaryColor,
                                  )),
                            ),
                            const SizedBox(height: 20.0),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _currentIndex = 2;
                                });
                                _pageController.animateToPage(_currentIndex,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.linearToEaseOut);
                              },
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: _currentIndex == 2
                                    ? kWhiteColor
                                    : kNavigationButtonColor,
                                child: Icon(
                                  Icons.business,
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
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          scrollDirection: Axis.vertical,
                          children: [
                            buildAddressContainer(
                                theme, Icons.home, locale.homeText, context),
                            buildAddressContainer(theme, Icons.account_balance,
                                locale.office, context),
                            buildAddressContainer(
                                theme, Icons.business, locale.other, context),
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
      ),
    );
  }

  Widget buildAddressContainer(
    ThemeData theme,
    IconData icon,
    String? text,
    BuildContext context,
  ) {
    var locale = AppLocalizations.of(context);
    return MapWidget(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(boxShadow: [boxShadow]),
            margin: const EdgeInsets.all(15.0),
            child: AddressField(
              initialValue: text,
              icon: icon == Icons.account_balance
                  ? Image.asset(
                      'images/ic_officewt.png',
                      scale: 3.5,
                      color: theme.primaryColor,
                    )
                  : Icon(icon, size: 20, color: theme.primaryColor),
              suffix: Icon(Icons.search, color: theme.hintColor),
              border: BorderSide.none,
            ),
          ),
          const Spacer(),
          Container(
              decoration: BoxDecoration(
                color: kButtonColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(35.0)),
              ),
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.navigation, color: theme.primaryColor),
                title: Text(
                  '2210 St. Merry Church, New York, NY 10013, United States',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )),
          Container(
            color: kWhiteColor,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                AddressField(
                  icon: Icon(Icons.star, size: 20, color: theme.primaryColor),
                  initialValue: locale.cityGarden,
                  color: kButtonColor,
                ),
                const SizedBox(height: 4),
                AddressField(
                  icon: Icon(Icons.person, size: 20, color: theme.primaryColor),
                  initialValue: 'Sam Smith',
                  suffix:
                      Icon(Icons.contacts, color: theme.primaryColor, size: 20),
                  color: kButtonColor,
                ),
                const SizedBox(height: 4),
                AddressField(
                  icon: Icon(Icons.phone, size: 20, color: theme.primaryColor),
                  initialValue: '+1 9876543210',
                  color: kButtonColor,
                ),
                CustomButton(
                  radius: BorderRadius.circular(35.0),
                  padding: 10,
                  text: '     ${locale.saveAddress2}     ',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
