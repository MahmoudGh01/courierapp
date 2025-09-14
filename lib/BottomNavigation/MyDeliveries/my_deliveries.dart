import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/QuickTransportRequest/quick_transport_request_page.dart';
import 'package:courier_app/Routes/routes.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/Theme/style.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';

import '../../Models/enums.dart';
import '../../Models/quick_transport_request_model.dart';
import '../../Models/transport_request_model.dart';
import '../../Pages/track_delivery.dart';
import '../../Service/deliveries_api.dart';

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
    // NOTE: You can replace these with your real lists (API/provider) later

  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme  = Theme.of(context);

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
            // Tab 1: Quick
            FutureBuilder(
              future: DeliveriesApi.fetchQuickRequests(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data as List<QuickTransportRequestModel>;
                if (items.isEmpty) {
                  return _emptyState(context, 'No Results Found');
                }

                // 👉 Show all in "Pending" (and empty "Past"). You can split by status if needed.
                return _buildTabListWithModels(
                  context,
                  titlePending: locale.pendingDeliv,
                  pendingModels: items,
                  titlePast: locale.pastDeliv,
                  pastModels: const [],
                );
              },
            ),

            // Tab 2: Transport
            FutureBuilder(
              future: DeliveriesApi.fetchTransportRequests(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data as List<TransportRequestModel>;
                if (items.isEmpty) {
                  return _emptyState(context, 'No Results Found');
                }
                return _buildTabListWithModels(
                  context,
                  titlePending: locale.pendingDeliv,
                  pendingModels: items,
                  titlePast: locale.pastDeliv,
                  pastModels: const [],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build one tab list (Pending + Past) using MODEL arrays directly.
  Widget _buildTabListWithModels(
      BuildContext context, {
        required String titlePending,
        required List<dynamic> pendingModels,
        required String titlePast,
        required List<dynamic> pastModels,
      }) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(35.0)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 56.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(35.0)),
          color: theme.cardColor,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                titlePending,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: theme.hoverColor.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildModelList(context, pendingModels),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                titlePast,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: theme.hoverColor.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildModelList(context, pastModels),
          ],
        ),
      ),
    );
  }

  /// Reusable list builder (handles both Quick & Transport models)
  Widget _buildModelList(BuildContext context, List<dynamic> models) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
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
  Widget _buildQuickCard(BuildContext context, QuickTransportRequestModel m) {
    final theme = Theme.of(context);
    const title = 'Quick Transport';
    final time = (m.createdAt ?? DateTime.now()).toLocal().toString().split('.').first;
    final status = m.status ?? '';
    final sender = m.originCity;
    final receiver = m.destinationCity;

    return _buildBaseCard(
      context,
      theme,
      title: title,
      time: time,
      status: status,
      price: '-',
      sender: sender,
      receiver: receiver,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QuickTransportItemPage(item: m)),
        );
      },
    );
  }

  /// TransportRequest card → goes to TrackDelivery
  Widget _buildTransportCard(BuildContext context, TransportRequestModel m) {
    final theme = Theme.of(context);
    const title = 'Transport Request';
    final time = (m.pickUpDate ?? DateTime.now()).toLocal().toString().split('.').first;
    final status = enumToString(m.status);
    final sender = m.originCity;
    final receiver = m.destinationCity;

    return _buildBaseCard(
      context,
      theme,
      title: title,
      time: time,
      status: status,
      price: '-',
      sender: sender,
      receiver: receiver,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TrackDelivery(item: m)),
        );
      },
    );
  }

  /// Shared card layout
  Widget _buildBaseCard(
      BuildContext context,
      ThemeData theme, {
        required String title,
        required String time,
        required String status,
        required String price,
        required String sender,
        required String receiver,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: InkWell(
        onTap: onTap,
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
                    child: Image.asset("images/home1.png"),
                  ),
                  title: Text(
                    title,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.primaryColorDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(time, style: theme.textTheme.titleMedium!.copyWith(fontSize: 12)),
                  trailing: RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$status\n',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.primaryColor,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: price,
                          style: theme.textTheme.titleMedium!.copyWith(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: theme.cardColor.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 90),
                      child: Text(sender, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                    ),
                    Icon(Icons.location_on, color: theme.primaryColor.withOpacity(0.3), size: 21.0),
                    Text("•••••••", style: theme.textTheme.bodySmall!.copyWith(color: theme.hoverColor.withOpacity(0.7))),
                    Icon(Icons.navigation, color: theme.primaryColor.withOpacity(0.3), size: 21.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 90),
                      child: Text(receiver, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
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

  Widget _emptyState(BuildContext context, String msg) {
  final theme = Theme.of(context);
  return Center(
    child: Text(
      msg,
      style: theme.textTheme.titleMedium?.copyWith(color: theme.hintColor),
    ),
  );
}}
