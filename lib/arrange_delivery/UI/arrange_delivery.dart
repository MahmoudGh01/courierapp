import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/custom_app_bar.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

import '../steps/pickup_step.dart';
import '../steps/drop_step.dart';
import '../steps/details_step.dart';
import '../steps/confirm_step.dart';

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
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goTo(int index) {
    setState(() => currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linearToEaseOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    final titles = [
      locale.pickupLoc,
      locale.dropLocation,
      locale.courierInfo,   // repurposed as "Details" step
      locale.confirmInfo
    ];

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
                CustomAppBar(title: titles[currentIndex]),
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
                            _navDot(Icons.location_on, 0),
                            const SizedBox(height: 20.0),
                            _navDot(Icons.navigation, 1),
                            const SizedBox(height: 20.0),
                            _navDot(Icons.assignment, 2),
                            const SizedBox(height: 20.0),
                            _navDot(Icons.check_circle, 3),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          physics: const BouncingScrollPhysics(),
                          controller: _pageController,
                          scrollDirection: Axis.vertical,
                          onPageChanged: (index) => setState(() => currentIndex = index),
                          children: [
                            PickupStep(onContinue: () => goTo(1)),
                            DropStep(onContinue: () => goTo(2)),
                            DetailsStep(onContinue: () => goTo(3)),
                            ConfirmStep(onSuccess: () {
                              // Pop and go to home
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            }),
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

  Widget _navDot(IconData icon, int index) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => goTo(index),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: kNavigationButtonColor,
        child: Icon(
          icon,
          color: theme.colorScheme.surface.withOpacity(currentIndex == index ? 1 : 0.3),
        ),
      ),
    );
  }
}
