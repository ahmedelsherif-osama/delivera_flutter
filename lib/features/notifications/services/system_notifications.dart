import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class SystemNotifications {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'default_channel',
    'General Notifications',
    description: 'This channel is used for general notifications',
    importance: Importance.high,
  );

  Future<void> initNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // ✅ Create the notification channel
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_channel);

    // ✅ Request permission (Android 13+)
    await _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.notification.request();
    print('🔔 Notification permission: $status');
  }

  Future<void> showSystemNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel', // must match the channel ID above
      'General Notifications',
      channelDescription: 'This channel is used for general notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique ID
      'New Notification',
      message,
      details,
    );

    print('✅ Notification shown: $message');
  }
}

final systemNotificationsProvider = Provider<SystemNotifications>((ref) {
  return SystemNotifications();
});
