// core/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Thin wrapper around flutter_local_notifications so the rest of the app
/// (price alerts, etc.) doesn't need to know about platform init details.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const String _channelId = 'price_alerts_channel';
  static const String _channelName = 'Price Alerts';
  static const String _channelDescription =
      'Notifications fired when a coin crosses your target price';

  Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(settings: initSettings);

    // Android 13+ needs the runtime notification permission requested
    // explicitly; iOS permissions are requested above via Darwin settings.
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  Future<void> showPriceAlert({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_initialized) {
      // Defensive: main() should have called init() already, but never
      // silently drop a fired alert.
      await init();
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
      );
    } catch (e) {
      debugPrint('NotificationService.showPriceAlert failed: $e');
    }
  }
}
