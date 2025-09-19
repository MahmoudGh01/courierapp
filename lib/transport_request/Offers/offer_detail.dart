import 'package:courier_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/offer_model.dart';
import '../../Theme/colors.dart';
import '../../ViewModels/offer_provider.dart';


class OfferDetailsPage extends StatelessWidget {
  final OfferModel offer;
  final int idRequest;
  const OfferDetailsPage({super.key, required this.offer, required this.idRequest});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // --- Determine banner style based on status ---
    Color bannerColor;
    Color borderColor;
    IconData icon;
    String bannerText;

    switch (offer.status.toUpperCase()) {
      case "ACCEPTED":
        bannerColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        icon = Icons.check_circle;
        bannerText =
        "Offer already accepted. A shipment has been created and assigned to the driver.";
        break;
      case "PENDING":
        bannerColor = Colors.orange.withOpacity(0.1);
        borderColor = Colors.orange;
        icon = Icons.hourglass_top;
        bannerText = "This offer is still pending.";
        break;
      case "REJECTED":
        bannerColor = Colors.red.withOpacity(0.1);
        borderColor = Colors.red;
        icon = Icons.cancel;
        bannerText = "This offer has been rejected.";
        break;
      default:
        bannerColor = Colors.grey.withOpacity(0.1);
        borderColor = Colors.grey;
        icon = Icons.info;
        bannerText = "Unknown status.";
    }

    Widget sectionCard({required String title, required Widget child}) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      );
    }

    Widget kv(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                k,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey[600]),
              )),
          Expanded(
              flex: 5,
              child: Text(v, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text("Offer Details"),
        centerTitle: true,
      ),
      backgroundColor: kWhiteColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: bannerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor),
              ),
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "#OF-${offer.idOffer}",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: borderColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 18, color: borderColor),
                            const SizedBox(width: 6),
                            Text(
                              "Created at ${offer.createdAt}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: borderColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ---- Driver Card
            sectionCard(
              title: "Driver Details",
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: Text(
                    offer.driver?.user?.name
                        .substring(0, 1)
                        .toUpperCase() ??
                        "?",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(offer.driver?.user?.name ?? 'Unknown',
                    style: theme.textTheme.titleMedium),
                subtitle: Text(
                    "Driver (Joined On ${offer.driver?.createdAt?.toLocal().toString().split(' ').first ?? 'N/A'})",
                    style: theme.textTheme.bodySmall),
                trailing: const Icon(Icons.verified, color: Colors.green),
              ),
            ),

            // ---- Driver Info
            sectionCard(
              title: "Driver Information",
              child: Column(
                children: [
                  kv("License Number", offer.driver?.licenseNumber ?? '—'),
                  kv("License Expiry Date",
                      offer.driver?.licenseExpiryDate.toIso8601String() ?? '—'),
                  kv("Vehicle Type", offer.driver?.vehicleType ?? '—'),
                  kv("Experience",
                      "${offer.driver?.yearsOfExperience ?? 0} years"),
                ],
              ),
            ),

            // ---- Contact Info
            sectionCard(
              title: "Contact Information",
              child: Column(
                children: [
                  kv("Email", offer.driver?.user?.email ?? '—'),
                  kv("Phone", offer.driver?.user?.phoneNumber ?? '—'),
                ],
              ),
            ),

            // ---- Offer Info
            sectionCard(
              title: "Offer Details",
              child: Column(
                children: [
                  kv("Price", "TND ${offer.price}"),
                  kv("Status", offer.status),
                  kv("Additional Info", offer.additionalInformation ?? "—"),
                ],
              ),
            ),

            // ---- Status Banner
            Card(
              color: bannerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor),
              ),
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(icon, color: borderColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        bannerText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: borderColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ---- Action Buttons (only show if status == PENDING)
            if (offer.status.toUpperCase() == "PENDING")
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                            color: Colors.red.shade400, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.close, color: Colors.red.shade400),
                      label: Text(
                        "Refuse",
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () async {
                        final ok = await Provider.of<OfferProvider>(
                          context,
                          listen: false,
                        ).refuseOfferT(offer.idOffer, idRequest);
                        if (ok) {
                          showSnackBar(context, "Offer Refused ❌");
                          Navigator.pop(context, true);
                        } else {
                          showSnackBar(context, "Failed to refuse offer ❌");
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        "Accept",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () async {
                        final ok = await Provider.of<OfferProvider>(
                          context,
                          listen: false,
                        ).acceptOfferT(offer.idOffer, idRequest);
                        if (ok) {
                          showSnackBar(context, "Offer Accepted ✅");
                          Navigator.pop(context, true);
                        } else {
                          showSnackBar(context, "Failed to accept offer ❌");
                        }
                      },
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
