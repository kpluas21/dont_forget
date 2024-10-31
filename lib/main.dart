import 'package:flutter/material.dart';
import 'models/medication.dart';
import 'mock/mock_medications.dart';

void main() {
  runApp(const MainApp());
}

//The main app that displays a list of medications
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get a mock list of medications
    List<Medication> medications = getMockMedications();
    medications += medications;
    medications += medications;

    return MaterialApp(
      home: Scaffold(
        // Display the list of medications
        body: ListView.builder(
          itemCount: medications.length,
          itemBuilder: (context, index) {
            final med = medications[index];
            return ListTile(
              title: Text('${med.name} - ${med.unit}'),
              subtitle: Text(medications[index].frequency.toString()),
            );
          },
        ),
        
        appBar: AppBar(
          title: const Text("Don't Forget"),
        ),
        drawer: const MainAppDrawer(),
      ),
    );
  }
}

//The main drawer for this app that persists throughout pages
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainApp()),
              );
            },
          ),
          ListTile(
            title: const Text('New Medication'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MedicationEntry()),
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

//The page for entering a new medication
class MedicationEntry extends StatelessWidget {
  const MedicationEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry'),
      ),
      body: const Center(
        child: Text('Medication Entry'),
      ),
      drawer: const MainAppDrawer(),
    );
  }
}
