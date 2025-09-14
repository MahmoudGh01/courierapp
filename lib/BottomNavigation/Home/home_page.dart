import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/plan_usage_banner.dart';
import '../../ViewModels/userprovider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class Card {
  Card(this.icon, this.title, this.subtitle, this.onPress);

  String icon;
  String? title;
  String? subtitle;
  final dynamic onPress;
}

class Ad {
  Ad(this.img, this.text, this.location);

  String img;
  String? text;
  String location;
}

class _HomeScreenState extends State<HomeScreen> {
  // If you have unread notifications count, you can set it here or from provider.
  int _unreadNotifications = 2;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    final List<Card> cards = [
      Card(
        "images/home1.png",
        locale.arrangeDeliv,
        locale.arrangeDelivText,
        PageRoutes.arrangeDeliveryPage,
      ),
      Card(
        "images/home2.png",
        locale.getFood,
        locale.getFoodText,
        PageRoutes.transportRequestWizard,
      ),
      Card(
        "images/home3.png",
        locale.getGrocery,
        locale.getGroceryText,
        PageRoutes.arrangeDeliveryPage,
      ),
    ];
    final List<Ad> ads = [
      Ad("images/promo1.png", "", "Yellas Fast Food"),
      Ad("images/promo2.png", "", "City Grocery Store"),
    ];

    final theme = Theme.of(context);
    var user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

        appBar: AppBar(
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          titleSpacing: 16,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // center align
            children: [
              Image.asset(
                'images/logo.png',
                height: 80,  // smaller, aligned with text height
              ),
              const SizedBox(width: 10),
              Text(
                'SheapIT',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: 'Notifications',
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: theme.primaryColor,
                      size: 26,
                    ),
                  ),
                  if (_unreadNotifications > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 64.0),
        children: [
          PlanUsageBanner(
            planName: user.plan?.name ?? '-',             // TODO: from provider
            quickUsed: user.usage!.quickTransportRequestsUsed ?? 0 ,                    // TODO: from provider
            quickLimit: user.plan!.limits?.quickTransportRequestsPerMonth ?? 0,                  // TODO: from provider
            transportUsed: user.usage?.transportRequestsUsed ?? 0,                // TODO: from provider
            transportLimit: user.plan!.limits?.transportRequestsPerMonth ?? 0,               // TODO: from provider
            onUpgrade: () {},                // TODO: open upgrade screen
            onDetails: () {},                // TODO: open usage details
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return buildCard(cards[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '\n${locale.promo}\n',
              style: theme.textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: ads.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => buildAdsContainer(ads[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(Card card) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, card.onPress),
      child: Container(
        margin: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: kWhiteColor,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 20.0),
          child: Row(
            children: [
              FadedScaleAnimation(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: Image.asset(
                    card.icon,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${card.subtitle}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.dividerColor,
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

  Container buildAdsContainer(Ad ad) {
    return Container(
      margin: const EdgeInsets.only(left: 8, bottom: 6.0),
      width: 210.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ad.img),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
