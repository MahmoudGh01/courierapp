import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Theme/colors.dart';
import '../Models/offer_model.dart';
import '../ViewModels/offer_provider.dart';
import 'offer_detail.dart';

class OffersListPage extends StatelessWidget {
  final int requestId; // pass requestId to fetch offers
  const OffersListPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offers"),
        centerTitle: true,
      ),
      backgroundColor: kWhiteColor,

      body: Consumer<OfferProvider>(
        builder: (context, offerProvider, child) {
          final offers = offerProvider.offers;

          if (offers.isEmpty) {
            return FutureBuilder(
              future: offerProvider.fetchOffers(requestId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (offers.isEmpty) return _buildEmptyState(context);
                return _buildOffersList(context, offers);
              },
            );
          }

          return _buildOffersList(context, offers);
        },
      ),
    );
  }

  Widget _buildOffersList(BuildContext context, List<OfferModel> offers) {
    // sort: accepted offers first, then others
    final sorted = [...offers]..sort((a, b) {
      if (a.status?.toUpperCase() == "ACCEPTED" && b.status?.toUpperCase() != "ACCEPTED") {
        return -1; // a comes first
      } else if (b.status?.toUpperCase() == "ACCEPTED" && a.status?.toUpperCase() != "ACCEPTED") {
        return 1; // b comes first
      }
      return 0; // keep same order
    });

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final offer = sorted[index];
        return GestureDetector(
          onTap: () async {
            final updated = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OfferDetailsPage(
                  offer: offer,
                  idRequest: requestId,
                ),
              ),
            );
            if (updated == true) {
              Provider.of<OfferProvider>(context, listen: false)
                  .fetchOffers(requestId);
            }
          },
          child: _buildOfferCard(context, offer),
        );
      },
    );
  }


  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 90, color: Colors.grey[350]),
          const SizedBox(height: 16),
          Text(
            "No offers available",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Once drivers send offers for your requests,\n they will appear here.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, OfferModel offer) {
    final theme = Theme.of(context);

    Color statusColor = Colors.orange;
    if (offer.status?.toUpperCase() == "ACCEPTED") statusColor = Colors.green;
    if (offer.status?.toUpperCase() == "REJECTED") statusColor = Colors.red;

    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          // --- Header with gradient + status badge
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusColor.withOpacity(0.2),
                  statusColor.withOpacity(0.05),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "#OF-${offer.idOffer}",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    offer.status ?? "Pending",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Body
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Driver block
                Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Icon(Icons.person,
                          color: theme.primaryColor, size: 34),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.driver?.user?.name ?? "Unknown Driver",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            offer.driver?.vehicleType ?? "Vehicle: —",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // License & Experience
                Row(
                  children: [
                    const Icon(Icons.badge, size: 20, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "License: ${offer.driver?.licenseNumber ?? '—'}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Icon(Icons.work_history,
                        size: 20, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "${offer.driver?.yearsOfExperience ?? 0} yrs exp",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Contact & Date
                Row(
                  children: [
                    const Icon(Icons.phone, size: 20, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        offer.driver?.user?.phoneNumber ?? "—",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const Icon(Icons.calendar_today,
                        size: 20, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat.yMMMd().format(offer.createdAt),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Price Chip
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.attach_money,
                            size: 22, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "TND ${offer.price}",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
