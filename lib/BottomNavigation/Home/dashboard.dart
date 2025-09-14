import 'package:flutter/material.dart';
import '../../Theme/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget statCard(String title, String value, String subtitle, IconData icon) {
      return Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.primaryColor, size: 28),
                Spacer(),
                Text(value,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    )),
              ],
            ),
            const SizedBox(height: 12),

            const SizedBox(height: 4),
            Text(title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,color: theme.primaryColor,
                )),
            const SizedBox(height: 4),
            Text(subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                )),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard",
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Welcome to your SheapIt dashboard.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 30),

              // Grid of stats
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    statCard("Transport Requests", "6",
                        "Total number of transport requests.", Icons.local_shipping),
                    statCard("Quick Transport Requests", "2",
                        "Total number of quick transport requests.", Icons.flash_on),
                    statCard("Shipments", "5",
                        "Total number of shipments.", Icons.inventory_2_outlined),
                    statCard("Offers", "5",
                        "Total number of offers.", Icons.local_offer_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
