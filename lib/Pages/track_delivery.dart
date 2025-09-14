import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:courier_app/Components/map_widget.dart';
import 'package:courier_app/Models/transport_request_model.dart';
import 'package:courier_app/Pages/slide_up_panel.dart';
import 'package:courier_app/Theme/colors.dart';
import 'package:courier_app/locale/locales.dart';
import 'package:flutter/material.dart';
class TrackDelivery extends StatefulWidget {
  final TransportRequestModel item;
  const TrackDelivery({super.key, required this.item});

  @override
  State<TrackDelivery> createState() => _TrackDeliveryState();
}

class _TrackDeliveryState extends State<TrackDelivery> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    final m = widget.item;

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
            title: FadedScaleAnimation(child: const Text('Track Delivery')),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          // --- Card header with model data ---
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsetsDirectional.only(top:4, bottom: 4, end: 16),
            margin: const EdgeInsets.symmetric(horizontal:10.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: FadedScaleAnimation(child: Image.asset('images/home1.png')),
              title: Text(
                m.serviceType,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                m.pickUpDate?.toLocal().toString() ?? 'No Date',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: const Color(0xffc1c1c1), height: 1.5, fontSize: 12),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(m.status,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: kMainColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(m.loadingCapacity,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: const Color(0xffc1c1c1))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          Expanded(
            child: MapWidget(
              addMarkers: true,
              request: null, // optional, if your MapWidget supports TransportRequest
              child: SlideUpPanel(item: m),
            ),
          ),
        ],
      ),
    );
  }
}
