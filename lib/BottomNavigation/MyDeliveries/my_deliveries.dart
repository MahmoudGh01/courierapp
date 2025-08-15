import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

class OrderCard {
  final String image;
  final String? title;
  final String time;
  final String? status;
  final String price;
  final String sender;
  final String receiver;

  OrderCard(this.image, this.title, this.time, this.status, this.price,
      this.sender, this.receiver);
}

class MyDeliveriesPage extends StatefulWidget {
  const MyDeliveriesPage({super.key});

  @override
  State<MyDeliveriesPage> createState() => _MyDeliveriesPageState();
}

class _MyDeliveriesPageState extends State<MyDeliveriesPage> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    final List<OrderCard> cards = [
      OrderCard(
          "images/home1.png",
          locale.arrangeDeliv,
          "20 Jun 2020, 11:40 am",
          locale.pickupAssigned,
          "\$ 8.50",
          "Emili Williamson",
          "Samantha Smith"),
      OrderCard(
          "images/home2.png",
          locale.getFood,
          "20 Jun 2020, 11:35 am",
          locale.wayToDeliver,
          "\$ 6.50",
          "Silver Leaf Restaurant",
          "Samantha Smith"),
    ];
    final List<OrderCard> pastDeliver = [
      OrderCard(
          "images/home3.png",
          locale.getGrocery,
          "18 Jun 2020, 1:48 pm",
          locale.delivered /*+ '\n'*/,
          "\$ 18.50",
          "7-11 Grocery Mart",
          "Samantha Smith"),
      OrderCard(
          "images/home2.png",
          locale.arrangeDeliv,
          "20 Jun 2020, 8:26 pm",
          locale.delivered /*+ '\n'*/,
          "\$ 20.50",
          "YOLO Fast Foods",
          "Samantha Smith"),
      OrderCard(
          "images/home3.png",
          locale.grocery,
          "18 Jun 2020, 1:48 pm",
          locale.delivered /*+ '\n'*/,
          "\$ 18.50",
          "7-11 Grocery Mart",
          "Samantha Smith"),
    ];
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Padding(
          padding: const EdgeInsets.only(top: 64, bottom: 48),
          child: Text(
            locale.myDeliv,
            textAlign: TextAlign.center,
            style: TextStyle(color: kWhiteColor, fontSize: 28),
          ),
        ),
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(35.0)),
        child: Container(
          margin: const EdgeInsets.only(bottom: 56.0),
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(35.0)),
            color: theme.cardColor,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  locale.pendingDeliv,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: theme.hoverColor.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              buildList(cards,
                  () => Navigator.pushNamed(context, PageRoutes.trackDelivery)),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  locale.pastDeliv,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: theme.hoverColor.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              buildList(pastDeliver,
                  () => Navigator.pushNamed(context, PageRoutes.trackDelivery)),
            ],
          ),
        ),
      ),
    );
  }

  ListView buildList(List<OrderCard> cards, [Function? onTap]) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return buildOrderCard(cards[index], onTap: onTap);
        });
  }

  Padding buildOrderCard(OrderCard card, {Function? onTap}) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            boxShadow: [boxShadow],
            borderRadius: BorderRadius.circular(10.0),
            color: kWhiteColor,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  contentPadding: const EdgeInsetsDirectional.only(end: 16),
                  leading: FadedScaleAnimation(
                    child: Image.asset(card.image),
                  ),
                  title: Text(
                    card.title!,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.primaryColorDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    card.time,
                    style: theme.textTheme.titleMedium!.copyWith(fontSize: 12),
                  ),
                  trailing: RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${card.status}\n',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.primaryColor,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text: card.price,
                          style: theme.textTheme.titleMedium!
                              .copyWith(fontSize: 14, height: 1.5)),
                    ]),
                  ),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                    color: theme.cardColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 90),
                      child: Text(
                        card.sender,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    FadedScaleAnimation(
                      child: Icon(
                        Icons.location_on,
                        color: theme.primaryColor.withOpacity(0.3),
                        size: 21.0,
                      ),
                    ),
                    Text(
                      "•••••••",
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: theme.hoverColor.withOpacity(0.7)),
                    ),
                    FadedScaleAnimation(
                      child: Icon(
                        Icons.navigation,
                        color: theme.primaryColor.withOpacity(0.3),
                        size: 21.0,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 90),
                      child: Text(
                        card.receiver,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
