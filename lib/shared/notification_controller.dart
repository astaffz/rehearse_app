import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rehearse_app/models/reminder_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class RehearseAppNotificationManager {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static final recievedResponses = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        fullScreenIntent: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future init() async {
    const android = AndroidInitializationSettings('app_icon');
    DarwinInitializationSettings iOS = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final initConfig = InitializationSettings(android: android, iOS: iOS);
    await _notificationsPlugin.initialize(initConfig,
        onDidReceiveBackgroundNotificationResponse: (details) async {
      recievedResponses.add(details.payload);
    });
  }

  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future scheduleNotification(
      {required int id,
      String title = Reminder.defaultTitle,
      required String body,
      String? payload,
      required DateTime date}) async {
    _notificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(date, tz.local), await _notificationDetails(),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
