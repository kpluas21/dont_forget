import 'package:dont_forget/routes/home_page.dart';
import 'package:flutter/material.dart';
import 'models/medication.dart';
import 'util/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final MedicationProvider medMgr = MedicationProvider();
final LocalNotificationService notificationService = LocalNotificationService();


void main() async {
  // Ensure that the FlutterLocalNotificationsPlugin is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  notificationService.init();


  // Run the app
  runApp(const MainApp());
}

// The main app widget
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Don\'t Forget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
