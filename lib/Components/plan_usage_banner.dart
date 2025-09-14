/// ---------- PlanUsageBanner.dart ----------
/// A pure-UI animated banner to show user's plan usage (design only).
/// Drop this widget at the TOP of your HomeScreen body ListView.

import 'package:flutter/material.dart';

class PlanUsageBanner extends StatelessWidget {
  // --- Inputs (plug your provider values later) ---
  final String planName;        // e.g., "Starter", "Pro"
  final int quickUsed;          // e.g., 3
  final int quickLimit;         // e.g., 10
  final int transportUsed;      // e.g., 1
  final int transportLimit;     // e.g., 5
  final VoidCallback? onUpgrade;
  final VoidCallback? onDetails;

  const PlanUsageBanner({
    super.key,
    required this.planName,
    required this.quickUsed,
    required this.quickLimit,
    required this.transportUsed,
    required this.transportLimit,
    this.onUpgrade,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                           // get theme

    // --- Derived percents (defensive: 0 if limit=0) ---
    final qPct = quickLimit == 0 ? 0.0 : (quickUsed / quickLimit).clamp(0, 1).toDouble();
    final tPct = transportLimit == 0 ? 0.0 : (transportUsed / transportLimit).clamp(0, 1).toDouble();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),        // outer padding
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),           // subtle expand/fade animation
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(14),                     // inner padding
        decoration: BoxDecoration(
          color: Colors.white, // ✅ solid white background

          borderRadius: BorderRadius.circular(16),             // rounded card
          gradient: LinearGradient(                            // soft gradient bg
            colors: [Colors.white, Colors.white.withOpacity(0.96)],

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(                                  // thin border
            color: theme.primaryColor.withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [                                         // soft drop shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,         // left align
          children: [
            // ---- Header row: plan + actions ----
            Row(
              children: [
                // Plan chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: theme.primaryColor.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.workspace_premium_outlined, size: 18, color: theme.primaryColor),
                      const SizedBox(width: 6),
                      Text(
                        'Plan: $planName',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Upgrade button
                TextButton.icon(
                  onPressed: onUpgrade,
                  icon: const Icon(Icons.arrow_circle_up_outlined, size: 18),
                  label: const Text('Upgrade'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.primaryColor,
                  ),
                ),
                // Details button

              ],
            ),
            const SizedBox(height: 12),

            // ---- Quick Requests row ----
            _usageRow(
              context: context,
              title: 'Quick Requests',
              used: quickUsed,
              limit: quickLimit,
              percent: qPct,
              icon: Icons.flash_on_rounded,
              barColor: Colors.amber,                           // progress bar color
            ),
            const SizedBox(height: 10),

            // ---- Transport Requests row ----
            _usageRow(
              context: context,
              title: 'Transport Requests',
              used: transportUsed,
              limit: transportLimit,
              percent: tPct,
              icon: Icons.local_shipping_outlined,
              barColor: theme.primaryColor,                     // progress bar color
            ),
          ],
        ),
      ),
    );
  }

  // -- Single usage row (icon + text + animated bar + count) --
  Widget _usageRow({
    required BuildContext context,
    required String title,
    required int used,
    required int limit,
    required double percent,
    required IconData icon,
    required Color barColor,
  }) {
    final theme = Theme.of(context);                            // theme
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,            // align center
      children: [
        // Icon
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
          ),
          child: Icon(icon, color: theme.primaryColor),
        ),
        const SizedBox(width: 12),
        // Title + progress
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,       // left align
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              // Animated progress bar
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: percent),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 8,
                      backgroundColor: theme.dividerColor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Usage counter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: theme.primaryColor.withOpacity(0.25)),
          ),
          child: Text(
            '$used / $limit',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.primaryColorDark,
            ),
          ),
        ),
      ],
    );
  }
}
