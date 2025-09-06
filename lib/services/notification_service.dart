import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
  }

  Future<void> scheduleDailyNotification(int id, String title, String body, int hour, int minute) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notifications', // channel id
          'Daily Notifications', // channel name
          channelDescription: 'Channel for daily reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, // Added this line
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Mock sending notifications
  Future<void> scheduleMockNotifications() async {
    await scheduleDailyNotification(0, '💧 Drink Water', 'Time to hydrate! Grab a glass of water.', 10, 0); // 10:00 AM
    await scheduleDailyNotification(1, '💪 Move Your Body', 'A short walk or some stretching can make a difference.', 16, 0); // 4:00 PM
    await scheduleDailyNotification(2, '😴 Time for Bed', 'Good night! Aim for 8 hours of sleep.', 22, 0); // 10:00 PM
  }
}
