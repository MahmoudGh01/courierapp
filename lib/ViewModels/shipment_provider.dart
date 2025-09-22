import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../Models/shipment_model.dart';
import '../Service/shipment_service.dart';
import '../utils/constants.dart';

class ShipmentProvider extends ChangeNotifier {
  List<Shipment> _shipments = [];
  Shipment? _selected;
  bool _loading = false;

  List<Shipment> get shipments => _shipments;
  Shipment? get selected => _selected;
  bool get loading => _loading;

  StompClient? _stomp;
  LatLng? _driverLocation;

  LatLng? get driverLocation => _driverLocation;

  bool get isTracking => _stomp?.connected ?? false;

  Future<void> startTracking({
    required int shipmentId,
  }) async {
    // if already connected, disconnect first
    stopTracking();
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('token') ?? '';
    _stomp = StompClient(
      config: StompConfig.sockJS(
        url: '${Constants.uri}ws',
        stompConnectHeaders: {'Authorization': 'Bearer $jwt'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $jwt'},
        onConnect: (StompFrame frame) {
          // subscribe to driver location
          _stomp?.subscribe(
            destination: '/topic/shipments/$shipmentId/location',
            callback: (msg) {
              if (msg.body == null) return;
              final data = jsonDecode(msg.body!);
              final lat = (data['lat'] as num).toDouble();
              final lng = (data['lng'] as num).toDouble();
              _driverLocation = LatLng(lat, lng);
              notifyListeners(); // UI updates
            },
          );
        },
        onWebSocketError: (err) {
          debugPrint('WS error: $err');
        },
        reconnectDelay: const Duration(seconds: 3),
        heartbeatOutgoing: const Duration(seconds: 10),
        heartbeatIncoming: const Duration(seconds: 10),
      ),
    );

    _stomp?.activate();
  }

  void stopTracking() {
    _stomp?.deactivate();
    _stomp = null;
    _driverLocation = null;
    notifyListeners();
  }

  Future<void> loadShipments() async {
    _loading = true;
    notifyListeners();
    try {
      _shipments = await ShipmentService.fetchShipments();
    } catch (e) {
      debugPrint('Error loading shipments: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadShipmentById(int id) async {
    _loading = true;
    notifyListeners();
    try {
      _selected = await ShipmentService.fetchShipmentById(id);
    } catch (e) {
      debugPrint('Error loading shipment $id: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
