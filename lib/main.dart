import 'package:flutter/material.dart';
import 'models/medication.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const Center(
          child: Text('Hello World!'),
        ),
        appBar: AppBar(
          title: const Text("Don't Forget"),
        ),
        drawer: const MainAppDrawer(),
      ),
    );
  }
}

class MainAppDrawer extends StatelessWidget {
  const MainAppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text('Medications'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              
            },
          )
        ],
      ),
    );
  }
}

class MedicationEntry extends StatelessWidget {
  const MedicationEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry'),
        ),
        body: Center(
          child:
        ))
  }
}