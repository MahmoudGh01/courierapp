import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/map_widget.dart';
import 'package:courier_app/Models/quick_transport_request_model.dart';
import 'package:courier_app/Offers/offers_list.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:flutter/material.dart';

import '../Theme/style.dart';

/// Minimal DTO (adapt to your real QuickTransportRequestListItem).


class QuickTransportItemPage extends StatelessWidget {
  final QuickTransportRequestModel item;
  const QuickTransportItemPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: AppBar(
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios, size: 24.0),
            ),
            title: FadedScaleAnimation(
              child: Text('Order ID ${item.idRequest}'),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          // ---- Header Card (same style as TrackDelivery) ----
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsetsDirectional.only(top: 4, bottom: 4, end: 16),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: FadedScaleAnimation(
                child: Image.asset("images/home1.png"),
              ),
              title: Text(
                "Quick Transport",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 16,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    (item.createdAt ?? DateTime.now()).toLocal().toString().split('.').first,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: const Color(0xffc1c1c1), height: 1.5, fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.status,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: kMainColor, fontWeight: FontWeight.bold, fontSize: 16,
                      )),
                  const SizedBox(height: 4),

                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // ---- Map + Slide Panel ----
          Expanded(
            child: MapWidget(
              addMarkers: true,
              request: item,

              child: _QuickSlideUpPanel(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

/// Slide panel with vertical cards (Details / Merchandise / Additional).
class _QuickSlideUpPanel extends StatefulWidget {
  final QuickTransportRequestModel item;
  const _QuickSlideUpPanel({required this.item});

  @override
  State<_QuickSlideUpPanel> createState() => _QuickSlideUpPanelState();
}

class _QuickSlideUpPanelState extends State<_QuickSlideUpPanel> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final it    = widget.item;

    return DraggableScrollableSheet(
      minChildSize: 0.2,
      initialChildSize: 0.5,
      maxChildSize: 1.0,
      builder: (context, scroll) {
        return ListView(
          controller: scroll, // use provided controller for proper drag/scroll
          padding: const EdgeInsets.symmetric(horizontal: 6.7),
          children: [
            // ---- Driver header style (optional) ----
            Container(
              decoration: BoxDecoration(
                boxShadow: [boxShadow],
                color: kWhiteColor,
                borderRadius: const BorderRadius.all(Radius.circular(35.0)),
              ),
              child: ListTile(
                leading: FadedScaleAnimation(
                  child: const CircleAvatar(
                    radius: 25.0,
                    backgroundImage: AssetImage('images/deliveryman.png'),
                  ),
                ),
                title: Text(
                  'Courier',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.primaryColorDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Delivery Man',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.hintColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                trailing: FadedScaleAnimation(
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: kMainColor,
                    child: Icon(Icons.phone, size: 24, color: kWhiteColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ---- Sender/Receiver card (same structure) ----
            _addressCard(theme, sender: it.originAddress, receiver: it.destinationAddress),

            const SizedBox(height: 10),



            // ---- Charge footer (same style as TrackDelivery) ----
            Container(
              decoration: BoxDecoration(
                boxShadow: [boxShadow],
                color: kWhiteColor,
                borderRadius: const BorderRadius.all(Radius.circular(35.0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                title: Text(
                  'View Offers ',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                trailing: FadedScaleAnimation(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OffersListPage()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: kMainColor,
                      child: Icon(Icons.arrow_forward_ios, size: 24, color: kWhiteColor),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  // ---------- helpers ----------

  Widget _addressCard(ThemeData theme, {required String sender, required String receiver}) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
      decoration: BoxDecoration(
        boxShadow: [boxShadow],
        color: kWhiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(35.0)),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.location_on, color: kMainColor.withOpacity(0.35)),
            title: Text(
              sender,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.primaryColorDark,
                height: 1.5,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Origin Address',
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(height: 12.0),
          ListTile(
            leading: Icon(Icons.navigation, color: kMainColor.withOpacity(0.35)),
            title: Text(
              receiver,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.primaryColorDark,
                height: 1.5,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

          ),
        ],
      ),
    );
  }

  Widget _sectionCard(BuildContext context, {required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [boxShadow],
        color: kWhiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(35.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColorDark,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _kvRow(BuildContext context, String k, String v) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(k, style: theme.textTheme.titleSmall?.copyWith(
              color: theme.hintColor.withOpacity(0.7),
            )),
          ),
          Expanded(
            flex: 7,
            child: Text(v, style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600, height: 1.4,
            )),
          ),
        ],
      ),
    );
  }

  Widget _emptyBox(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(text, style: theme.textTheme.bodyMedium),
    );
  }

  Widget _tableHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _thCell(context, 'Item', flex: 3),
          _thCell(context, 'Quantity', flex: 2),
          _thCell(context, 'Dimensions (cm)', flex: 4),
          _thCell(context, 'Weight (kg)', flex: 3),
        ],
      ),
    );
  }

  Widget _tableRow(BuildContext context, String i, String q, String d, String w) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(i, style: theme.textTheme.bodyMedium)),
          Expanded(flex: 2, child: Text(q, style: theme.textTheme.bodyMedium)),
          Expanded(flex: 4, child: Text(d, style: theme.textTheme.bodyMedium)),
          Expanded(flex: 3, child: Text(w, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _thCell(BuildContext context, String label, {int flex = 1}) {
    final theme = Theme.of(context);
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.primaryColorDark,
        ),
      ),
    );
  }
}
