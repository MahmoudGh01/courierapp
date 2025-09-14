import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/enums.dart';
import '../../ViewModels/transport_request_provider.dart';
import '../../Theme/colors.dart';
import '../../ViewModels/userprovider.dart';

class Step1ServiceType extends StatelessWidget {
  final VoidCallback onNext;
  const Step1ServiceType({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final p     = context.watch<TransportRequestProvider>();
    final theme = Theme.of(context);
    final user  = Provider.of<UserProvider>(context, listen: false).user.idUser;
    print(user);
    Widget chip(ServiceType t, String title, String subtitle) {
      final String tName   = t.name; // enum → string
      final bool selected  = p.dto.serviceType == tName;

      return InkWell(
        onTap: () {
          context.read<TransportRequestProvider>().setServiceType(tName);
          context.read<TransportRequestProvider>().setUser(user);
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.28,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? theme.primaryColor.withOpacity(0.1) : kWhiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? theme.primaryColor
                  : theme.dividerColor.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.local_shipping,
                  color: selected ? theme.primaryColor : theme.hintColor,
                  size: 40),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              const Spacer(),
              if (selected)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.check_circle,
                      color: theme.primaryColor, size: 28),
                )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Step 1 of 8 — Service Type',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  chip(ServiceType.RELOCATION, 'Relocation',
                      'Move your cargo from one location to another.'),
                  chip(ServiceType.FREIGHT_TRANSPORTATION,
                      'Freight Transportation',
                      'Transport your cargo from one location to another.'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: onNext,
                child: const Text(
                  'Continue  ↓',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
