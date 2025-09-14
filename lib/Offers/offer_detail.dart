import 'package:flutter/material.dart';
import '../../Theme/colors.dart';

class OfferDetailsPage extends StatelessWidget {
  const OfferDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget sectionTitle(String title) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.primaryColor,
        ),
      ),
    );

    Widget kv(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(k, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey))),
          Expanded(flex: 5, child: Text(v, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(surfaceTintColor: Colors.white ,backgroundColor: Colors.white,
        title: const Text("Offer Details"),
        centerTitle: true,
      ),
      backgroundColor: kWhiteColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---- Offer ID + Date
            Text("#OF-F13AC46E",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text("Created at Thursday, 11 September 2025",
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
            const Divider(height: 20),

            // ---- Driver Details
            sectionTitle("Driver Details"),
            ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: theme.primaryColor.withOpacity(0.1),
                child: const Text("M"),
              ),
              title: Text("Meriam Ben Doudou (Tunisia, Hammamet)",
                  style: theme.textTheme.titleMedium),
              subtitle: Text("Driver (Joined On September 2nd, 2025)",
                  style: theme.textTheme.bodySmall),
              trailing: const Icon(Icons.verified, color: Colors.green),
            ),

            // ---- Driver Info
            sectionTitle("Driver Information"),
            kv("License Number", "123445555"),
            kv("License Expiry Date", "Sep 14, 2029"),
            kv("Vehicle Type", "Medium Truck"),
            kv("Experience", "3 years"),

            const Divider(height: 20),

            // ---- Contact
            sectionTitle("Contact Information"),
            kv("Email", "ahmed.bendoudou@eyeotech.com"),
            kv("Phone", "(+216) 52334838"),

            const Divider(height: 20),

            // ---- Offer Details
            sectionTitle("Offer Details"),
            kv("Price", "TND 500"),
            kv("Status", "Accepted"),
            kv("Additional Info",
                "sdsdscfdfdfsfdsvdsvdsvdsvdsvdsfvsdvdfvdfvdfs"),

            const Divider(height: 20),

            // ---- Accepted Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Offer already accepted. A shipment has been created and assigned to the driver.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // ---- Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.remove_red_eye),
                    label: const Text("View"),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Accepted"),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
