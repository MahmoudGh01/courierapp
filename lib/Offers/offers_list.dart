import 'package:flutter/material.dart';
import '../../Theme/colors.dart';
import 'offer_detail.dart';

class OffersListPage extends StatelessWidget {
  const OffersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mock data (you will replace with backend API data)
    final offers = [
      {
        "id": "#OF-F13AC46E",
        "date": "Thursday, 11 September 2025",
        "driver": "Meriam Ben Doudou",
        "location": "Tunisia, Hammamet",
        "price": "TND 500",
        "status": "Accepted",
      },
      {
        "id": "#OF-98D2A7B1",
        "date": "Friday, 12 September 2025",
        "driver": "Ahmed Trabelsi",
        "location": "Tunisia, Tunis",
        "price": "TND 430",
        "status": "Pending",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Offers"),
        centerTitle: true,
      ),
      backgroundColor: kWhiteColor,
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OfferDetailsPage()),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with ID + status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          offer["id"]!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: offer["status"] == "Accepted"
                                ? Colors.green.withOpacity(0.15)
                                : Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            offer["status"]!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: offer["status"] == "Accepted"
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Driver name + location
                    Text(
                      "${offer["driver"]} (${offer["location"]})",
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),

                    // Date
                    Text(
                      "Created at ${offer["date"]}",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                    const Divider(height: 16),

                    // Price
                    Row(
                      children: [
                        Icon(Icons.local_shipping,
                            size: 18, color: theme.primaryColor),
                        const SizedBox(width: 6),
                        Text(
                          offer["price"]!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
