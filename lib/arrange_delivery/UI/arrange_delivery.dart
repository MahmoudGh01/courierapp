import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/arrange_delivery/UI/deliveryconfirm_info.dart';
import 'package:courier_app/arrange_delivery/UI/measurement.dart';
import 'package:courier_app/Components/address_field.dart';
import 'package:courier_app/Components/continue_button.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Components/map_widget.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class ArrangeDeliveryPage extends StatelessWidget {
  const ArrangeDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArrangeDeliveryBody();
  }
}

class ArrangeDeliveryBody extends StatefulWidget {
  const ArrangeDeliveryBody({super.key});

  @override
  State<ArrangeDeliveryBody> createState() => _ArrangeDeliveryBodyState();
}

class _ArrangeDeliveryBodyState extends State<ArrangeDeliveryBody> {
  int currentIndex = 0;
  bool isPickupLocationSelected = false;
  PageController? _pageController;

  double? weight = 5;
  bool isSwitched = false;
  Measured? measured;
  double? width = 0;
  double? length = 0;
  double? height = 0;
  int selectedCourierTypeIndex = 1;
  final List<String> courierTypes = [];
  bool areCourierTypesAdded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void didChangeDependencies() {
    final locale = AppLocalizations.of(context);
    if (!areCourierTypesAdded) {
      courierTypes.addAll([
        locale.electronics,
        locale.household,
        locale.clothes,
        locale.paperDocument,
        locale.flowerChocolate,
        locale.other,
      ]);
    }
    areCourierTypesAdded = true;
    super.didChangeDependencies();
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
                CustomAppBar(
                    title: currentIndex == 0
                        ? locale.pickupLoc
                        : currentIndex == 1
                            ? locale.dropLocation
                            : currentIndex == 2
                                ? locale.courierInfo
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
                              child: FadedScaleAnimation(
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: currentIndex == 0
                                      ? kNavigationButtonColor
                                      : kNavigationButtonColor,
                                  child: Icon(
                                    Icons.location_on,
                                    color: theme.colorScheme.surface
                                        .withOpacity(
                                            currentIndex == 0 ? 1 : 0.3),
                                  ),
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
                              child: FadedScaleAnimation(
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: currentIndex == 1
                                      ? kNavigationButtonColor
                                      : kNavigationButtonColor,
                                  child: Icon(
                                    Icons.navigation,
                                    color: theme.colorScheme.surface
                                        .withOpacity(
                                            currentIndex == 1 ? 1 : 0.3),
                                  ),
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
                              child: FadedScaleAnimation(
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: currentIndex == 2
                                      ? kNavigationButtonColor
                                      : kNavigationButtonColor,
                                  child: Icon(
                                    Icons.shopping_basket,
                                    color: theme.colorScheme.surface
                                        .withOpacity(
                                            currentIndex == 2 ? 1 : 0.3),
                                  ),
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
                              child: FadedScaleAnimation(
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: currentIndex == 3
                                      ? kNavigationButtonColor
                                      : kNavigationButtonColor,
                                  child: Icon(
                                    Icons.assignment,
                                    color: theme.colorScheme.surface
                                        .withOpacity(
                                            currentIndex == 3 ? 1 : 0.3),
                                  ),
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
                            buildPage(theme, locale, context, locale.pickup),
                            buildPage(theme, locale, context, locale.drop),
                            buildCourierInfo(theme, locale, context),
                            ConfirmInfo(
                                height!.toInt().toString(),
                                width!.toInt().toString(),
                                weight!.toInt().toString(),
                                length!.toInt().toString(),
                                'No'),
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

  // _navigateAndGetData(BuildContext context) async {
  //   measured = await Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => const Measurement()));
  //   setState(() {
  //     height = measured!.height;
  //     length = measured!.length;
  //     width = measured!.width;
  //   });
  // }

  Widget buildPage(ThemeData theme, AppLocalizations locale,
      BuildContext context, String page) {
    return MapWidget(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(boxShadow: [boxShadow]),
            margin: const EdgeInsetsDirectional.only(
                top: 12.0, start: 16.0, end: 10.0),
            child: AddressField(
              color: kWhiteColor,
              icon: Icon(
                page == locale.pickup ? Icons.location_on : Icons.navigation,
                color: theme.primaryColor,
              ),
              hint: page == locale.pickup ? locale.pickupHint : locale.dropHint,
            ),
          ),
          page == locale.pickup && !isPickupLocationSelected
              ? const SizedBox.shrink()
              : const Spacer(),
          page == locale.pickup && !isPickupLocationSelected
              ? Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [boxShadow],
                        color: kWhiteColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 20.0,
                      ),
                      margin: const EdgeInsetsDirectional.only(
                          start: 16.0, end: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(locale.savedAddresses,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: theme.hintColor)),
                          buildListTile(
                            locale.homeText,
                            icon: Icons.home,
                          ),
                          buildListTile(locale.office),
                          buildListTile(locale.other, icon: Icons.business),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [boxShadow],
                        color: kWhiteColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      margin: const EdgeInsetsDirectional.only(
                          start: 16.0, end: 10.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            locale.recentSearch,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: theme.hintColor),
                          ),
                          buildListTile(
                            'City Centre',
                            icon: Icons.restore,
                          ),
                          buildListTile(
                            'Walmart Campus',
                            icon: Icons.restore,
                          ),
                          buildListTile(
                            'Golden Point',
                            icon: Icons.restore,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: kButtonColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(35.0)),
                        ),
                        child: ListTile(
                          leading: Icon(
                              page == locale.pickup && isPickupLocationSelected
                                  ? Icons.location_on
                                  : Icons.navigation,
                              color: theme.primaryColor),
                          title: Text(
                            page == locale.pickup && isPickupLocationSelected
                                ? '128 Mott St. New York, NY 10013, United States'
                                : '2210 St. Merry Church, New York, NY 10013, United States',
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
                            icon: Icon(Icons.star,
                                size: 20, color: theme.primaryColor),
                            initialValue: locale.cityGarden,
                            color: kButtonColor,
                            readOnly: true,
                          ),
                          const SizedBox(height: 4),
                          AddressField(
                            icon: Icon(Icons.person,
                                size: 20, color: theme.primaryColor),
                            initialValue: 'Sam Smith',
                            suffix: Icon(Icons.contacts,
                                color: theme.primaryColor, size: 20),
                            color: kButtonColor,
                            readOnly: true,
                          ),
                          const SizedBox(height: 4),
                          AddressField(
                            icon: Icon(Icons.phone,
                                size: 20, color: theme.primaryColor),
                            initialValue: '+1 9876543210',
                            color: kButtonColor,
                            readOnly: true,
                          ),
                          CustomButton(
                            radius: BorderRadius.circular(35.0),
                            padding: 10,
                            text: '     ${locale.continueText}  ↓    ',
                            onPressed: () {
                              setState(() {
                                currentIndex++;
                              });
                              _pageController!.animateToPage(currentIndex,
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.linearToEaseOut);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  Widget buildCourierInfo(
      ThemeData theme, AppLocalizations locale, BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        color: kWhiteColor,
        child: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        locale.courierType,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        itemCount: courierTypes.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return CustomButton(
                            onPressed: () {
                              setState(() {
                                selectedCourierTypeIndex = index;
                              });
                            },
                            text: courierTypes[index],
                            padding: 12,
                            color: index == selectedCourierTypeIndex
                                ? null
                                : kButtonColor,
                            borderColor: kButtonTextColor.withOpacity(0.6),
                            radius: BorderRadius.circular(30.0),
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: index == selectedCourierTypeIndex
                                          ? theme.colorScheme.surface
                                          : theme.hintColor,
                                    ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                // Divider(thickness: 6, color: kButtonColor),
                // InkWell(
                //   onTap: () {
                //     _navigateAndGetData(context);
                //   },
                //   child: IntrinsicHeight(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: <Widget>[
                //         buildCalcCard(Icons.arrow_upward, locale.height,
                //             '$height ${locale.cm}', theme),
                //         VerticalDivider(thickness: 6, color: kButtonColor),
                //         buildCalcCard(Icons.arrow_forward, locale.width,
                //             '$width ${locale.cm}', theme),
                //         VerticalDivider(thickness: 6, color: kButtonColor),
                //         buildCalcCard(Icons.compare_arrows, locale.length,
                //             '$length ${locale.cm}', theme),
                //       ],
                //     ),
                //   ),
                // ),
                // Divider(thickness: 6, color: kButtonColor),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: Column(
                //     children: [
                //       Row(
                //         children: <Widget>[
                //           Text(
                //             locale.weight,
                //             style: Theme.of(context).textTheme.bodyLarge,
                //           ),
                //           Expanded(
                //             child: FlutterSlider(
                //               handlerHeight: 60,
                //               handler: FlutterSliderHandler(
                //                 child: Container(
                //                   height: 16,
                //                   width: 2,
                //                   color: theme.primaryColor,
                //                   margin: const EdgeInsets.only(bottom: 20),
                //                 ),
                //                 decoration:
                //                     const BoxDecoration(shape: BoxShape.rectangle),
                //               ),
                //               hatchMark: FlutterSliderHatchMark(
                //                 density: 0.5,
                //                 bigLine: FlutterSliderSizedBox(
                //                     height: 16,
                //                     width: 2,
                //                     decoration: BoxDecoration(
                //                         color:
                //                             theme.disabledColor.withOpacity(0.3))),
                //                 smallLine: FlutterSliderSizedBox(
                //                     height: 8,
                //                     width: 1,
                //                     decoration: BoxDecoration(
                //                         color:
                //                             theme.disabledColor.withOpacity(0.3))),
                //                 displayLines: true,
                //                 linesAlignment:
                //                     FlutterSliderHatchMarkAlignment.left,
                //                 labelsDistanceFromTrackBar: 28,
                //                 labels: [
                //                   FlutterSliderHatchMarkLabel(
                //                       label: Text(
                //                         '0 kg',
                //                         style: Theme.of(context).textTheme.bodySmall,
                //                       ),
                //                       percent: 0),
                //                   FlutterSliderHatchMarkLabel(
                //                       label: Text(
                //                         '20 kg',
                //                         style: Theme.of(context).textTheme.bodySmall,
                //                       ),
                //                       percent: 100),
                //                   FlutterSliderHatchMarkLabel(
                //                       label: Text(
                //                         '10 kg',
                //                         style: Theme.of(context).textTheme.bodySmall,
                //                       ),
                //                       percent: 50),
                //                 ],
                //               ),
                //               values: [weight!],
                //               min: 0,
                //               max: 20,
                //               onDragging: (index, lowerValue, upperValue) {
                //                 setState(() {
                //                   weight = lowerValue;
                //                 });
                //               },
                //               trackBar: FlutterSliderTrackBar(
                //                   activeTrackBarHeight: 0.1,
                //                   activeTrackBar: BoxDecoration(
                //                     color: kWhiteColor,
                //                   ),
                //                   inactiveTrackBarHeight: 0.1),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 8),
                Divider(thickness: 6, color: kButtonColor),
                ListTile(
                  title: Text(
                    '${locale.frangible} ?',
                    style: theme.textTheme.bodyLarge,
                  ),
                  trailing: FittedBox(
                    child: Row(
                      children: [
                        Text(
                          isSwitched ? locale.yes : locale.no,
                          style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                            });
                          },
                          activeTrackColor: theme.hintColor.withOpacity(0.3),
                          activeColor: theme.primaryColor,
                          inactiveTrackColor: theme.hintColor.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 6, color: kButtonColor),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${locale.courierDetail}\n',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: locale.courierInput,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: theme.hintColor),
                          filled: true,
                          fillColor: kButtonColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                            //gapPadding: 3.3
                          ),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                // Divider(thickness: 6, color: kButtonColor),
              ],
            ),
            PositionedDirectional(
              end: 15,
              bottom: 40,
              child: CustomButton(
                radius: BorderRadius.circular(35.0),
                padding: 10,
                text: '      ${locale.continueText}  ↓    ',
                onPressed: () {
                  setState(() {
                    currentIndex++;
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
    );
  }

  ListTile buildListTile(String text, {IconData? icon}) {
    return ListTile(
      onTap: () {
        setState(() {
          isPickupLocationSelected = true;
        });
      },
      contentPadding: EdgeInsets.zero,
      leading: icon != null
          ? Icon(
              icon,
              color: Theme.of(context).primaryColor,
            )
          : Image.asset(
              'images/ic_officeblk.png',
              color: Theme.of(context).primaryColor,
              scale: 3.5,
            ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      dense: true,
    );
  }

  Widget buildCalcCard(
      IconData icon, String text, String measurement, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                size: 16,
                color: theme.primaryColor,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(text,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: kButtonTextColor, fontSize: 11.7)),
            ],
          ),
          const SizedBox(
            height: 7.5,
          ),
          Text(measurement,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: kContainerTextColor))
        ],
      ),
    );
  }
}
