import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
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
    
    // Request permissions for Android
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();


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

  void showNotificationAndroid(String title, String value) async {

    int notificationId = 1;
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        notificationId, title, value, notificationDetails,
        payload: 'item x');
  }


  // Schedule a notification for a specific time
  void scheduleNotificationAndroid(int notificationId, String title, String value, DateTime scheduledTime) async {
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    
    //Given a DateTime, convert it to a TZDateTime that is in the local timezone. 
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
    
    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(notificationId, title, value,
        tzScheduledTime, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
}
