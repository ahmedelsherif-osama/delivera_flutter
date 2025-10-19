import 'dart:async';
import 'package:delivera_flutter/features/notifications/services/system_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_core/signalr_core.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

class NotificationService {
  final Ref ref;
  HubConnection? _hubConnection;

  NotificationService(this.ref);

  Future<void> connect(String accessToken, String userId) async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.connected) {
      print("SignalR already connected");
      return;
    }

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          "http://localhost:5208/hubs/notifications",
          HttpConnectionOptions(
            accessTokenFactory: () async => accessToken,
            transport: HttpTransportType.webSockets,
          ),
        )
        .withAutomaticReconnect()
        .build();

    // Register handler for receiving notifications
    _hubConnection!.on("Receive Notification", (args) {
      if (args != null && args.isNotEmpty) {
        final notification = args.first;
        print("📩 New notification: $notification");

        ref
            .read(systemNotificationsProvider)
            .showSystemNotification(notification["message"]);
        // Here you can update a provider or show a local notification
      }
    });

    _hubConnection!.onreconnecting((_) => print("🔄 Reconnecting..."));
    _hubConnection!.onreconnected((_) => print("✅ Reconnected to SignalR"));
    _hubConnection!.onclose((_) => print("❌ SignalR connection closed"));

    await _hubConnection!.start();
    print("✅ SignalR connected");

    // Join the user’s private group
    await _hubConnection!.invoke("JoinUserGroup", args: [userId]);
    print("👥 Joined user group $userId");
  }

  Future<void> disconnect(String userId) async {
    if (_hubConnection == null) return;
    await _hubConnection!.invoke("LeaveUserGroup", args: [userId]);
    await _hubConnection!.stop();
    print("🔌 Disconnected from SignalR");
  }
}
