import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/QuickTransportRequest/quick_transport_request_page.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/ViewModels/quick_request_provider.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Models/enums.dart';
import '../../Models/quick_transport_request_model.dart';
import '../../Models/transport_request_model.dart';
import '../../Pages/track_delivery.dart';
import '../../Service/deliveries_api.dart';
import '../../ViewModels/userprovider.dart';

class OrderCard {
  final String image;
  final String? title;
  final String time;
  final String? status;
  final String price;
  final String sender;
  final String receiver;

  OrderCard(
      this.image,
      this.title,
      this.time,
      this.status,
      this.price,
      this.sender,
      this.receiver,
      );
}

class MyDeliveriesPage extends StatefulWidget {
  const MyDeliveriesPage({super.key});

  @override
  State<MyDeliveriesPage> createState() => _MyDeliveriesPageState();
}

class _MyDeliveriesPageState extends State<MyDeliveriesPage> {
  // --- Demo data: split into two tabs ---
  late final List<OrderCard> quickRequestsPending;
  late final List<OrderCard> quickRequestsPast;

  late final List<OrderCard> transportRequestsPending;
  late final List<OrderCard> transportRequestsPast;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<QuickRequestProvider>(context, listen: false);
    var user = Provider.of<UserProvider>(context, listen: false).user;

    provider.fetchQuickRequests(user.idUser.toString());
    provider.fetchTransportRequests(user.idUser.toString());
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme  = Theme.of(context);

    var user = Provider.of<UserProvider>(context, listen: false).user;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              locale.myDeliv,
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          bottom: TabBar(
            labelColor: theme.primaryColor,
            unselectedLabelColor: theme.hintColor,
            indicatorColor: theme.primaryColor,
            tabs: const [
              Tab(text: 'Quick Transport Requests'),
              Tab(text: 'Transport Requests'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [

            // --- Quick Requests ---
            Consumer<QuickRequestProvider>(
              builder: (context, provider, _) {
                return RefreshIndicator(
                  onRefresh: () => provider.fetchQuickRequests(user.idUser.toString()), // 🟢 pull-to-refresh
                  child: provider.loadingQuick
                      ? const Center(child: CircularProgressIndicator())
                      : provider.quickRequests.isEmpty
                      ? _emptyState(context, "No Quick Requests")
                      : _buildModelList(context, provider.quickRequests),
                );
              },
            ),

            // --- Transport Requests ---
            Consumer<QuickRequestProvider>(
              builder: (context, provider, _) {
                return RefreshIndicator(
                  onRefresh: () => provider.fetchTransportRequests(user.idUser.toString()), // 🟢 pull-to-refresh
                  child: provider.loadingTransport
                      ? const Center(child: CircularProgressIndicator())
                      : provider.transportRequests.isEmpty
                      ? _emptyState(context, "No Transport Requests")
                      : _buildModelList(context, provider.transportRequests),
                );
              },
            ),
          ],
        ),

      ),
    );
  }


  /// Reusable list builder (handles both Quick & Transport models)
  Widget _buildModelList(BuildContext context, List<dynamic> models) {
    return ListView.builder(
      itemCount: models.length,
      itemBuilder: (context, index) {
        final m = models[index];
        if (m is QuickTransportRequestModel) {
          return _buildQuickCard(context, m);
        } else if (m is TransportRequestModel) {
          return _buildTransportCard(context, m);
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// QuickTransport card → goes to QuickTransportItemPage
  /// QuickTransport card → QuickTransportItemPage
  Widget _buildQuickCard(BuildContext context, QuickTransportRequestModel m) {
    final theme = Theme.of(context);

    final createdAt = (m.createdAt ?? DateTime.now());
    final pickUp = m.pickUpDate ?? DateTime.now();
    final delivery = m.deliveryDate;

    return _buildBaseCard(
      context,
      theme,
      title: 'Quick Transport',
      time: DateFormat.yMMMd().format(createdAt),
      status: m.status ?? '',
      price: '-', // ⚡️ tu peux remplacer si ton modèle a un champ prix
      sender: m.originCity,
      receiver: m.destinationCity,
      pickUpDate: DateFormat.yMMMd().format(pickUp),
      deliveryDate: delivery != null ? DateFormat.yMMMd().format(delivery) : 'N/A',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QuickTransportItemPage(item: m)),
        );
      },
    );
  }

  /// TransportRequest card → TrackDelivery
  Widget _buildTransportCard(BuildContext context, TransportRequestModel m) {
    final theme = Theme.of(context);

    final pickUp = m.pickUpDate ?? DateTime.now();
    final delivery = m.deliveryDate;

    return _buildBaseCard(
      context,
      theme,
      title: 'Transport Request',
      time: DateFormat.yMMMd().format(m.createdAt ?? DateTime.now()),
      status: enumToString(m.status),
      price: '-', // ⚡️ pareil, adapte si modèle contient un prix
      sender: m.originCity,
      receiver: m.destinationCity,
      pickUpDate: DateFormat.yMMMd().format(pickUp),
      deliveryDate: delivery != null ? DateFormat.yMMMd().format(delivery) : 'N/A',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TrackDelivery(item: m)),
        );
      },
    );
  }

  Widget _buildBaseCard(
      BuildContext context,
      ThemeData theme, {
        required String title,
        required String time,
        required String status,
        required String price,
        required String sender,
        required String receiver,
        required String pickUpDate,
        required String deliveryDate,
        required VoidCallback onTap,
      }) {
    // --- Status color
    Color statusColor = Colors.orange;
    if (status.toUpperCase() == "PUBLISHED" || status.toUpperCase() == "ACCEPTED") {
      statusColor = Colors.green;
    } else if (status.toUpperCase() == "REJECTED" || status.toUpperCase() == "CANCELLED") {
      statusColor = Colors.red;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
        decoration: BoxDecoration(
          boxShadow: [boxShadow],
          borderRadius: BorderRadius.circular(10.0),
          color: theme.colorScheme.surface,
        ),
        child: Column(
          children: <Widget>[
            // --- Top Row (title + createdAt + status badge)
            Row(
              children: [
                Image.asset('images/home1.png', width: 60),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 4),
                      Text(time,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor)),
                    ],
                  ),
                ),
                Container(
                  height: 36,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- Dates Row
            Row(
              children: <Widget>[
                const SizedBox(width: 76.0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Pick-up date\n',
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.hintColor,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: pickUpDate,
                          style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Delivery date\n',
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.hintColor,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: deliveryDate,
                          style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),

            // --- Bottom Row (cities)
            Container(
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xfffafafa),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 90),
                    child: Text(sender,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall),
                  ),
                  Icon(Icons.location_on,
                      color: theme.primaryColor.withOpacity(0.4), size: 21.0),
                  Text("•••••••",
                      style: theme.textTheme.bodySmall!.copyWith(
                          color: theme.hoverColor.withOpacity(0.7))),
                  Icon(Icons.navigation,
                      color: theme.primaryColor.withOpacity(0.4), size: 21.0),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 90),
                    child: Text(receiver,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context, String msg) {
  final theme = Theme.of(context);
  return Center(
    child: Text(
      msg,
      style: theme.textTheme.titleMedium?.copyWith(color: theme.hintColor),
    ),
  );
}}
