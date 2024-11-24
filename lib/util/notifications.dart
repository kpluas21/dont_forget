import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

///A class that pairs two notification ids together
/// oneTime: For the initial reminder
/// recurring: For the recurring reminders based on the frequency provided.
class NotificationIdPair<T1, T2> {
  int? oneTime;
  int? recurring;

  NotificationIdPair({this.oneTime, this.recurring});
}

class LocalNotificationService with ChangeNotifier {
  final List<int> _notifications = [];
  List<int> get notifications => _notifications;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Define the Android notification settings
  final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('med_reminder', 'Medication Reminder',
          channelDescription: 'Channel for medication reminders',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');

  Future<void> init() async {
    // Initialize the timezone
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    if (kDebugMode) {
      print('Current timezone: $currentTimeZone');
    }
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // Request permissions for Android
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Initialize the notification plugin
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize the settings
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: initializationSettingsAndroid,
      ),
    );
  }

  // Schedule a notification for a specific time
  /// Once the first notification finishes, the next notification will be scheduled
  /// on a recurring basis
  Future<void> scheduleNotificationAndroid(int notificationId, String title,
      String value, DateTime scheduledTime) async {
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    //Given a DateTime, convert it to a TZDateTime that is in the local timezone.
    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    if (kDebugMode) {
      print('Scheduled time: $scheduledTime');
      print('tzScheduled time: $tzScheduledTime');
    }

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, title, value, tzScheduledTime, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'item x');
  }

  Future<void> _scheduleNotificationAndroid(int notificationId, String title,
      String value, DateTime scheduledTime) async {
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    //Given a DateTime, convert it to a TZDateTime that is in the local timezone.
    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    if (kDebugMode) {
      print('Scheduled time: $scheduledTime');
      print('tzScheduled time: $tzScheduledTime');
    }

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, title, value, tzScheduledTime, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'item x');
  }


  int _generateNotificationId() {
    int id;
    id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    return id;
  }

 
  // Adds a notification id to the list
  // Schedules a notification for a specific time
  int addNotifications(DateTime scheduledTime) {
    int notificationId = _generateNotificationId();
    _notifications.add(notificationId);
    scheduleNotificationAndroid(
        notificationId, "Don't Forget!", "Take your medication", scheduledTime);
    notifyListeners();
    return notificationId;
  }

  void removeNotification(int notificationId) async {
    _notifications.remove(notificationId);
    await flutterLocalNotificationsPlugin.cancel(notificationId);
    notifyListeners();
  }
 void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    _notifications.clear();
    notifyListeners();
  }


  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  void printNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await getPendingNotifications();
    for (PendingNotificationRequest pendingNotificationRequest
        in pendingNotificationRequests) {
      if (kDebugMode) {
        print(pendingNotificationRequest.id);
      }
    }
  }
}
