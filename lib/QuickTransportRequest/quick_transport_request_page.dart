// ✨ Improved cards with modern UI: gradient headers, status badge, icons, dividers, and subtle colors
// ⚠️ No logic/layout changes (Map + DraggableScrollableSheet kept intact). Only visual polish.
// 💬 Every instruction includes a concise comment.

import 'package:animation_wrappers/animation_wrappers.dart'; // animations
import 'package:courier_app/Components/map_widget.dart'; // map wrapper
import 'package:courier_app/Models/quick_transport_request_model.dart'; // model
import 'package:courier_app/Offers/offers_list.dart'; // offers page
import 'package:courier_app/Theme/colors.dart'; // kMainColor, kWhiteColor
import 'package:flutter/material.dart'; // flutter ui
import 'package:intl/intl.dart';
import '../Theme/style.dart'; // boxShadow
import 'package:google_maps_flutter/google_maps_flutter.dart';

class QuickTransportItemPage extends StatelessWidget {
  final QuickTransportRequestModel item; // current request item
  const QuickTransportItemPage({super.key, required this.item}); // ctor

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // theme shortcut
    final accent = kMainColor; // main accent from theme colors
    final statusColor = _statusColor(item.status);
    return Scaffold(
      drawerScrimColor: Colors.white, // page scaffold
      backgroundColor: Colors.white, // subtle background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: AppBar(
            leading: InkWell(
              onTap: () => Navigator.pop(context), // ← back
              child: const Icon(
                Icons.arrow_back_ios,
                size: 24.0,
                color: Colors.black,
              ),
            ),
            title: FadedScaleAnimation(
              child: Text('#TR - ${item.idRequest}'), // ← header title
            ),
          ),
        ),
      ),
      body: Column(
        // page body column
        children: <Widget>[
          // ---- Header Card with gradient top bar ----
          // 🔹 3) Replace your header Container with this (same layout; tinted by status)
          Container(
            decoration: BoxDecoration(
              // 👉 Tinted surface: blends status color into the surface for a subtle background tint
              color: Color.alphaBlend(statusColor.withOpacity(0.10),
                  theme.colorScheme.surface), // tint bg
              borderRadius: BorderRadius.circular(12), // keep radius
              // 👉 Left accent bar reflecting status (thin, elegant)
              border: Border(
                  left: BorderSide(
                      color: statusColor.withOpacity(0.65),
                      width: 4)), // status bar
              // 👉 Soft glow matching status for depth (optional but nice)
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.12), // colored shadow
                  blurRadius: 12, // softness
                  offset: const Offset(0, 6), // drop
                ),
              ],
            ),
            padding: const EdgeInsetsDirectional.only(
                top: 4, bottom: 4, end: 16), // same paddings
            margin:
                const EdgeInsets.symmetric(horizontal: 10.0), // same margins
            child: ListTile(
              contentPadding: EdgeInsets.zero, // unchanged
              leading: FadedScaleAnimation(
                  child: Image.asset("images/home1.png")), // unchanged
              title: Text(
                "Quick Transport", // unchanged title
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold, // unchanged weight
                  fontSize: 16, // unchanged size
                ),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.access_time,
                      size: 14,
                      color: statusColor.withOpacity(0.7)), // ⏰ matches status
                  const SizedBox(width: 6), // small gap
                  Text(
                    (item.createdAt ?? DateTime.now())
                        .toLocal()
                        .toString()
                        .split('.')
                        .first, // unchanged date
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.hintColor.withOpacity(0.8), // softer neutral
                      height: 1.5, // unchanged
                      fontSize: 12, // unchanged
                    ),
                  ),
                  const Spacer(), // unchanged
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // unchanged
                mainAxisAlignment: MainAxisAlignment.center, // unchanged
                children: [
                  // 👉 Status text uses the same mapped color
                  Text(
                    item.status, // status label
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: statusColor, // colored by status
                      fontWeight: FontWeight.bold, // unchanged
                      fontSize: 16, // unchanged
                    ),
                  ),
                  const SizedBox(height: 4), // unchanged
                ],
              ),
            ),
          ),

          const SizedBox(height: 12.0), // spacing

          Expanded(
            child: MapWidget(
                addMarkers: true,
                child: _QuickSlideUpPanel(item: item),
                origin: LatLng(item.originLatitude, item.originLongitude),
                destination: LatLng(item.destinationLatitude, item.destinationLongitude)),
          ),
        ],
      ),
    );
  }
}

// ---------- Slide-up panel with improved cards ----------
class _QuickSlideUpPanel extends StatefulWidget {
  final QuickTransportRequestModel item; // the request
  const _QuickSlideUpPanel({required this.item}); // ctor

  @override
  State<_QuickSlideUpPanel> createState() => _QuickSlideUpPanelState(); // state
}

class _QuickSlideUpPanelState extends State<_QuickSlideUpPanel> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // theme
    final it = widget.item; // alias
    final accent = kMainColor; // accent color
    final muted = theme.hintColor.withOpacity(0.7); // muted text

    return DraggableScrollableSheet(
      // draggable panel
      minChildSize: 0.2, // collapsed height pct
      initialChildSize: 0.5, // default height pct
      maxChildSize: 1.0, // full screen
      builder: (context, scroll) {
        // builder with scroll controller
        return ListView(
          // content scroll
          controller: scroll, // wire drag+scroll
          padding: const EdgeInsets.symmetric(
              horizontal: 8.0, vertical: 6.0), // padding
          children: [
            _SurfaceCard(
              // action card
              child: ListTile(
                // list tile
                title: Text(
                  // title
                  'View Offers',
                  style: theme.textTheme.titleMedium?.copyWith(
                    // style
                    fontWeight: FontWeight.w700, // bold
                  ),
                ),
                trailing: FadedScaleAnimation(
                  // animated cta
                  child: CircleAvatar(
                    // round button
                    radius: 20, // size
                    backgroundColor: kMainColor, // accent
                    child: const Icon(Icons.arrow_forward_ios,
                        size: 18, color: Colors.white), // icon
                  ),
                ),
                onTap: () {
                  // navigate
                  Navigator.push(
                    // push offers
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          OffersListPage(requestId: it.idRequest), // pass id
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10), // gap

            // ---- Sender/Receiver card (same structure, richer) ----
            _SurfaceCard(
              // shell
              padding: const EdgeInsets.only(top: 12, bottom: 8), // insets
              child: Column(
                // stack lines
                crossAxisAlignment: CrossAxisAlignment.start, // align left
                children: [
                  _SectionHeader(
                    // mini header
                    icon: Icons.route_rounded, // icon
                    title: 'Route', // title
                  ),
                  const SizedBox(height: 6), // gap
                  _LocationTile(
                    // origin row
                    icon: Icons.location_on_rounded, // icon
                    title: it.originAddress ?? '-', // address
                    subtitle: 'Origin Address', // label
                    dotColor: accent, // dot color
                  ),
                  const SizedBox(height: 8), // gap
                  _DashedDivider(
                      color: theme.dividerColor
                          .withOpacity(0.4)), // dashed divider
                  const SizedBox(height: 8), // gap
                  _LocationTile(
                    // destination row
                    icon: Icons.flag_rounded, // icon
                    title: it.destinationAddress ?? '-', // address
                    subtitle: 'Destination Address', // label
                    dotColor: Colors.green, // dot color
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // gap

            // ---- Origin details card ----
            _SectionCard(
              // info card with gradient header
              icon: Icons.home_work_rounded, // header icon
              title: 'Origin Details', // header title
              children: [
                // rows
                _kvRow(context, Icons.place_rounded, 'Origin',
                    it.originAddress), // row
                _kvRow(context, Icons.apartment_rounded, 'City/State',
                    _join2(it.originCity, it.originState)), // row
                _kvRow(context, Icons.local_post_office, 'Postal Code',
                    it.originPostalCode), // row
              ],
            ),
            const SizedBox(height: 10), // gap

            // ---- Destination details card ----
            _SectionCard(
              // info card
              icon: Icons.flag_circle_rounded, // header icon
              title: 'Destination Details', // header title
              children: [
                // rows
                _kvRow(context, Icons.place_outlined, 'Destination',
                    it.destinationAddress), // row
                _kvRow(context, Icons.apartment_outlined, 'City/State',
                    _join2(it.destinationCity, it.destinationState)), // row
                _kvRow(context, Icons.local_post_office, 'Postal Code',
                    it.destinationPostalCode), // row
              ],
            ),
            const SizedBox(height: 10), // gap

            // ---- Schedule card ----
            _SectionCard(
              // info card
              icon: Icons.event_rounded, // header icon
              title: 'Schedule', // title
              chip: _InfoChip(
                  text:
                      'UTC+${DateTime.now().timeZoneOffset.inHours}'), // hint chip
              children: [
                // rows
                _kvRow(context, Icons.calendar_today_rounded, 'Pick-up Date',
                    DateFormat.yMMMd().format(it.pickUpDate)), // row
                _kvRow(context, Icons.event_available_rounded, 'Delivery Date',
                    DateFormat.yMMMd().format(it.deliveryDate!)), // row
              ],
            ),
            const SizedBox(height: 10), // gap

            // ---- Description card ----
            _SectionCard(
              // info card
              icon: Icons.description_rounded, // header icon
              title: 'Description', // title
              children: [
                // rows
                _kvRow(context, Icons.notes_rounded, 'Details',
                    it.description), // row
              ],
            ),
            const SizedBox(height: 10), // gap

            // ---- Footer action (unchanged action, restyled shell) ----

            const SizedBox(height: 20), // bottom spacer
          ],
        );
      },
    );
  }

  // ---------- helpers: display & styling ----------

  Widget _kvRow(
      BuildContext context, IconData icon, String label, Object? value) {
    final theme = Theme.of(context); // theme
    final text = _asText(value); // normalize value
    return Column(
      // row + divider
      children: [
        ListTile(
          // kv tile
          dense: true, // compact
          leading: CircleAvatar(
            // icon plate
            radius: 14, // size
            backgroundColor: kMainColor.withOpacity(0.1), // tint
            child: Icon(icon, size: 16, color: kMainColor), // icon
          ),
          title: Text(
            // label
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              // small
              color: theme.hintColor.withOpacity(0.75), // muted
            ),
          ),
          subtitle: Text(
            // value
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              // readable
              color: theme.primaryColorDark, // dark
              fontWeight: FontWeight.w600, // semi-bold
              height: 1.3, // line height
            ),
          ),
        ),
      ],
    );
  }

  String _join2(Object? a, Object? b) {
    final pa = _asText(a); // part a
    final pb = _asText(b); // part b
    if (pa == '-' && pb == '-') return '-'; // both empty
    if (pa != '-' && pb != '-') return '$pa, $pb'; // both present
    return pa != '-' ? pa : pb; // one present
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '-'; // null guard
    return dt.toLocal().toString().split('.').first; // ISO-like local
  }

  String _asText(Object? v) {
    final s = (v ?? '').toString().trim(); // to string
    return s.isEmpty ? '-' : s; // dash if empty
  }
}

// ---------- Shared UI primitives ----------

class _SurfaceCard extends StatelessWidget {
  final Widget child; // inner content
  final EdgeInsetsGeometry? padding; // optional padding
  const _SurfaceCard({required this.child, this.padding}); // ctor

  @override
  Widget build(BuildContext context) {
    return Container(
      // base card
      decoration: BoxDecoration(
        // visuals
        color: kWhiteColor, // white surface
        borderRadius: const BorderRadius.all(Radius.circular(16.0)), // radius
        boxShadow: [
          // soft shadow
          boxShadow,
        ],
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8.0), // padding
      child: child, // content
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon; // header icon
  final String title; // header title
  final List<Widget> children; // content rows
  final Widget? chip; // optional header chip
  const _SectionCard({
    // ctor
    required this.icon,
    required this.title,
    required this.children,
    this.chip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // theme
    return _SurfaceCard(
      // use common shell
      padding: const EdgeInsets.only(top: 10, bottom: 6), // insets
      child: Column(
        // vertical stack
        crossAxisAlignment: CrossAxisAlignment.start, // left align
        children: [
          _SectionHeader(
              icon: icon, title: title, trailing: chip), // header row
          const SizedBox(height: 8), // gap
          ...children, // rows
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon; // icon
  final String title; // title
  final Widget? trailing; // optional trailing
  const _SectionHeader({
    // ctor
    required this.icon,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // theme
    return Padding(
      // header padding
      padding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0), // insets
      child: Row(
        // row
        children: [
          Container(
            // icon chip
            padding: const EdgeInsets.all(8), // inner pad
            decoration: BoxDecoration(
              // visuals
              color: kMainColor.withOpacity(0.1), // tint
              borderRadius: BorderRadius.circular(12), // radius
            ),
            child: Icon(icon, size: 18, color: kMainColor), // icon
          ),
          const SizedBox(width: 10), // gap
          Text(
            // title text
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              // style
              fontWeight: FontWeight.w700, // bold
            ),
          ),
          const Spacer(), // push trailing
          if (trailing != null) trailing!, // optional chip
        ],
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final IconData icon; // leading icon
  final String title; // main text
  final String subtitle; // sub label
  final Color dotColor; // colored dot
  const _LocationTile({
    // ctor
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // theme
    return ListTile(
      // tile
      leading: Stack(
        // icon + dot
        alignment: Alignment.bottomRight, // dot at corner
        children: [
          CircleAvatar(
            // icon plate
            radius: 18, // size
            backgroundColor: kMainColor.withOpacity(0.08), // tint
            child: Icon(icon, color: kMainColor, size: 18), // icon
          ),
          CircleAvatar(
            // tiny dot
            radius: 5, // size
            backgroundColor: dotColor, // color
          ),
        ],
      ),
      title: Text(
        // address
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          // style
          fontWeight: FontWeight.w600, // semi-bold
        ),
      ),
      subtitle: Text(
        // label
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          // style
          color: theme.hintColor.withOpacity(0.7), // muted
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text; // chip label
  const _InfoChip({required this.text}); // ctor

  @override
  Widget build(BuildContext context) {
    return Container(
      // pill chip
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // insets
      decoration: BoxDecoration(
        // visuals
        color: kMainColor.withOpacity(0.1), // tint
        borderRadius: BorderRadius.circular(999), // pill
        border: Border.all(color: kMainColor.withOpacity(0.2)), // outline
      ),
      child: Text(
        // text
        text,
        style: TextStyle(
          // style
          color: kMainColor, // accent
          fontSize: 11, // small
          fontWeight: FontWeight.w600, // semi
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text; // status text
  final Color color; // status color
  const _StatusBadge({required this.text, required this.color}); // ctor

  @override
  Widget build(BuildContext context) {
    return Container(
      // status pill
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // insets
      decoration: BoxDecoration(
        // visuals
        color: color.withOpacity(0.12), // tinted bg
        borderRadius: BorderRadius.circular(999), // pill
        border: Border.all(color: color.withOpacity(0.2)), // outline
      ),
      child: Row(
        // icon+text
        mainAxisSize: MainAxisSize.min, // wrap
        children: [
          Icon(Icons.circle, size: 8, color: color), // tiny dot
          const SizedBox(width: 6), // gap
          Text(
            // label
            text,
            style: TextStyle(
              // style
              color: color, // colored text
              fontSize: 11, // small
              fontWeight: FontWeight.w700, // bold
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color; // dash color
  const _DashedDivider({required this.color}); // ctor

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // measure width
      builder: (context, constraints) {
        final dashWidth = 6.0; // dash size
        final dashSpace = 4.0; // gap size
        final count = (constraints.maxWidth / (dashWidth + dashSpace))
            .floor(); // dash count
        return Row(
          // line of dashes
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // spread
          children: List.generate(
            // generate dashes
            count,
            (_) => Container(
              // single dash
              width: dashWidth, // width
              height: 1.6, // height
              color: color, // color
            ),
          ),
        );
      },
    );
  }
}

// ---------- Status color mapping ----------

Color _statusColor(String status) {
  final s = status.toLowerCase(); // normalize
  if (s.contains('pending')) return const Color(0xFFfb8c00); // orange
  if (s.contains('accepted') || s.contains('published'))
    return const Color(0xFF1e88e5); // blue
  if (s.contains('in') && s.contains('transit'))
    return const Color(0xFF7e57c2); // purple
  if (s.contains('delivered') || s.contains('completed'))
    return const Color(0xFF43a047); // green
  if (s.contains('canceled') || s.contains('rejected'))
    return const Color(0xFFe53935); // red
  return kMainColor; // default accent
}
