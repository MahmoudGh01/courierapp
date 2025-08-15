import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

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
        PageRoutes.arrangeDeliveryPage,
      ),
      Card(
        "images/home3.png",
        locale.getGrocery,
        locale.getGroceryText,
        PageRoutes.arrangeDeliveryPage,
      ),
    ];
    final List<Ad> ads = [
      Ad(
        "images/promo1.png",
        "",
        "Yellas Fast Food",
      ),
      Ad(
        "images/promo2.png",
        "",
        "City Grocery Store",
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 64.0),
        children: [
          Stack(
            children: [
              FadedScaleAnimation(
                child: Image.asset(
                  "images/banner.png",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 230),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return buildCard(cards[index]);
                    }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '\n${locale.promo}\n',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: ads.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return buildAdsContainer(ads[index]);
                }),
          )
        ],
      ),
    );
  }

  Widget buildCard(Card card) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, card.onPress),
      child: Container(
        margin: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        decoration: BoxDecoration(
          // boxShadow: [boxShadow],
          borderRadius: BorderRadius.circular(10.0),
          color: kWhiteColor,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            // top: 20.0,
            // bottom: 20.0,
            end: 20.0,
          ),
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
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${card.subtitle}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Theme.of(context).dividerColor),
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
        // boxShadow: [boxShadow],
        image: DecorationImage(
            // colorFilter: ColorFilter.mode(
            //     Colors.black.withOpacity(0.45), BlendMode.darken),
            image: AssetImage(ad.img),
            fit: BoxFit.fill),
        borderRadius: BorderRadius.circular(10.0),
      ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: <Widget>[
      //     Padding(
      //       padding: const EdgeInsets.all(12.0),
      //       child: Text(
      //         ad.text!,
      //         style: Theme.of(context)
      //             .textTheme
      //             .titleMedium!
      //             .copyWith(color: Theme.of(context).backgroundColor),
      //       ),
      //     ),
      //     const Spacer(),
      //     Padding(
      //       padding: const EdgeInsets.all(12.0),
      //       child: Row(
      //         children: <Widget>[
      //           Icon(
      //             Icons.location_on,
      //             size: 18.0,
      //             color: Theme.of(context).primaryColor,
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 8),
      //             child: Text(
      //               ad.location,
      //               style: Theme.of(context).textTheme.titleSmall,
      //             ),
      //           )
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
