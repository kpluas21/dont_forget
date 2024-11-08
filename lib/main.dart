import 'package:dont_forget/routes/home_page.dart';
import 'package:flutter/material.dart';
import 'models/medication.dart';
import 'util/notifications.dart';

final MedicationProvider medMgr = MedicationProvider();

void main() async {
  // Ensure that the FlutterLocalNotificationsPlugin is initialized
  WidgetsFlutterBinding.ensureInitialized();


  // Initialize the local notification service
  await LocalNotificationService().init();

  // Run the app
  runApp(const MainApp());
}

// The main app widget
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
