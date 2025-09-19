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
    // => Keep the same entry widget
    return const ArrangeDeliveryBody();
  }
}

class ArrangeDeliveryBody extends StatefulWidget {
  const ArrangeDeliveryBody({super.key});

  @override
  State<ArrangeDeliveryBody> createState() => _ArrangeDeliveryBodyState();
}

class _ArrangeDeliveryBodyState extends State<ArrangeDeliveryBody> {
  // => Current step index (unchanged logic)
  int currentIndex = 0;

  // => Programmatic navigation between steps (no PageController needed)
  void goTo(int index) {
    // => Update the current step
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // => Localizations for titles
    final locale = AppLocalizations.of(context);
    // => Screen metrics
    final mediaQuery = MediaQuery.of(context);
    // => Step titles (same design/logic)
    final titles = [
      locale.pickupLoc,
      locale.dropLocation,
      locale.courierInfo, // "Details" step label
      locale.confirmInfo,
    ];

    return Scaffold(
      // => Slide+fade the whole page in (same wrapper you had)
      body: FadedSlideAnimation(
        beginOffset: const Offset(0, 0.3), // => Start offset for entrance
        endOffset: const Offset(0, 0),     // => End at original place
        slideCurve: Curves.linearToEaseOut, // => Same easing
        // => Disable any vertical scrolling (keeps layout stable)
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(), // => No scroll
          child: SizedBox(
            height: mediaQuery.size.height, // => Fill screen height
            child: Column(
              children: [
                const Spacer(), // => Keep same vertical spacing above AppBar
                CustomAppBar(title: titles[currentIndex]), // => Dynamic title
                const Spacer(), // => Keep same spacing below AppBar
                SizedBox(
                  height: mediaQuery.size.height * 0.85, // => Same content box
                  child: Row(
                    children: [
                      // => Left vertical nav dots (unchanged)
                      SizedBox(
                        width: 68, // => Fixed width rail
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
                      // ===== RIGHT CONTENT: Animated, no PageView =====
                      Expanded(
                        // => AnimatedSwitcher to mimic page change without scroll
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500), // => Same 500ms
                          switchInCurve: Curves.linearToEaseOut,        // => Same curve
                          switchOutCurve: Curves.linearToEaseOut,       // => Symmetric
                          transitionBuilder: (child, anim) {
                            // => Fade + slight slide to feel like a page transition
                            final slide = Tween<Offset>(
                              begin: const Offset(0.0, 0.08), // => Subtle vertical slide-in
                              end: Offset.zero,
                            ).animate(anim);
                            return FadeTransition(
                              opacity: anim, // => Fade in/out
                              child: SlideTransition(
                                position: slide, // => Slide in/out
                                child: child,    // => New step content
                              ),
                            );
                          },
                          // => IndexedStack keeps state of offstage steps (logic unchanged)
                          child: _buildStep(currentIndex),
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

  // => Builds the current step wrapped with a stable key for AnimatedSwitcher
  Widget _buildStep(int index) {
    // => Choose step by index (same order/logic)
    switch (index) {
      case 0:
        return KeyedSubtree(
          key: const ValueKey('pickup'),
          child: PickupStep(onContinue: () => goTo(1)), // => Next step
        );
      case 1:
        return KeyedSubtree(
          key: const ValueKey('drop'),
          child: DropStep(onContinue: () => goTo(2)), // => Next step
        );
      case 2:
        return KeyedSubtree(
          key: const ValueKey('details'),
          child: DetailsStep(onContinue: () => goTo(3)), // => Next step
        );
      case 3:
      default:
        return KeyedSubtree(
          key: const ValueKey('confirm'),
          child: ConfirmStep(
            onSuccess: () {
              // => Pop to root (unchanged completion logic)
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        );
    }
  }

  // => Left rail dot that navigates to a specific step (unchanged design)
  Widget _navDot(IconData icon, int index) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => goTo(index), // => Jump without scroll
      child: CircleAvatar(
        radius: 24, // => Same size
        backgroundColor: kNavigationButtonColor, // => Same color
        child: Icon(
          icon, // => Step icon
          color: theme.colorScheme.surface
              .withOpacity(currentIndex == index ? 1 : 0.3), // => Active/idle
        ),
      ),
    );
  }
}
