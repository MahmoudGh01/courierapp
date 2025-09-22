import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../utils/constants.dart';

StompClient buildStomp(
    String token, {
      StompFrameCallback? onConnect,
    }) {
  return StompClient(
    config: StompConfig.sockJS(
      url: '${Constants.uri}ws',
      onConnect: onConnect!,
      onWebSocketError: (e) => print('WS error $e'),
      connectionTimeout: const Duration(seconds: 6),
      stompConnectHeaders: {'Authorization': 'Bearer $token'},
      webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      heartbeatOutgoing: const Duration(seconds: 10),
      heartbeatIncoming: const Duration(seconds: 10),
      reconnectDelay: const Duration(seconds: 3),
    ),
  );
}
