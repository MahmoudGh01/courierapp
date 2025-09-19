import 'dart:convert';
import 'package:courier_app/Models/quick_transport_request_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../Components/continue_button.dart';
import '../../Theme/colors.dart';
import '../../ViewModels/quick_request_provider.dart';
import '../../ViewModels/userprovider.dart';
import '../../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmStep extends StatelessWidget {
  final VoidCallback onSuccess;
  const ConfirmStep({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quick = context.watch<QuickRequestProvider>().quickRequest;
    final user = context.watch<UserProvider>().user;

    return Container(
      color: kWhiteColor,
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Confirm your request', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          _kv('Origin', quick.originAddress),
          _kv('Origin City/State', '${quick.originCity}, ${quick.originState}'),
          _kv('Origin PostalCode', quick.originPostalCode),
          _kv('Destination', quick.destinationAddress),
          _kv('Destination City/State', '${quick.destinationCity}, ${quick.destinationState}'),
          _kv('Destination PostalCode', quick.destinationPostalCode),
          _kv('Pick-up Date', quick.pickUpDate?.toIso8601String() ?? '-'),
          _kv('Delivery Date', quick.deliveryDate?.toIso8601String() ?? '-'),
          _kv('Description', quick.description),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Submit',
            radius: BorderRadius.circular(35),
            onPressed: () async {
              final ok = await _submitQuickRequest(context, quick, user.idUser);
              print(user.idUser);
              if (ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Request submitted successfully')),
                );
                onSuccess();
                context.read<QuickRequestProvider>().reset();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Submission failed')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  Future<bool> _submitQuickRequest(
      BuildContext context,
      QuickTransportRequestModel quick,
      int userId,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    final payload = quick.toJson(userId: userId);
    print(payload);

    var res = await http.post(
      Uri.parse('${Constants.uri}QuickTransportRequest/add-QuickTransportRequest/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    // 🔄 refresh token if expired
    if (res.statusCode == 403) {
      final refreshed = await context.read<UserProvider>().refreshToken();
      if (!refreshed) return false;

      token = prefs.getString('token') ?? '';
      res = await http.post(
        Uri.parse('${Constants.uri}QuickTransportRequest/add-QuickTransportRequest/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );
    }

    final success = res.statusCode == 200 || res.statusCode == 201;

    if (success) {
      // ✅ après succès → reload user data
      final userProvider = context.read<UserProvider>();
      await userProvider.fetchUserData(); // ta méthode qui recharge le user (QuickRequests inclus)
      userProvider.notifyListeners();           // force rebuild si nécessaire
    }

    return success;
  }

}
