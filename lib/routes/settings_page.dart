import 'package:dont_forget/main.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 61, 110, 202),
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Settings Page'),
            ElevatedButton(
              onPressed: () {
                notificationService.printNotifications();

                // Add functionality here
              },
              child: const Text('Show Pending Notifications'),
            ),
            ElevatedButton(
              onPressed: () {
                notificationService.cancelAllNotifications();
              },
              child: const Text('Cancel All Pending Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
