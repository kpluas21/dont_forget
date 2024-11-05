import 'package:dont_forget/medication_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/medication.dart';
import 'mock/mock_medications.dart';

//Lists of possible values for medication properties
final List<Frequency> frequencies = Frequency.values;
final List<MeasurementUnit> units = MeasurementUnit.values;
final List<MedicationType> types = MedicationType.values;

final MedicationProvider medMgr = MedicationProvider();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

//The main app that displays a list of medications
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load the list of medications from local storage
    loadMedications().then((medications) {
      setState(() {
        medMgr.medications.addAll(medications);
      });
    });
  }

  void _addMedication(Medication newMed) {
    setState(() {
      medMgr.addMedication(newMed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple, brightness: Brightness.light),
      ),
      home: Builder(builder: (context) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MedicationEntry(onAdd: (newMed) {
                            _addMedication(newMed);
                          })));
            },
            child: const Icon(Icons.add),
          ),
          // Display the list of medications
          body: ListView.builder(
            itemCount: medMgr.medications.length,
            itemBuilder: (context, index) {
              final med = medMgr.medications[index];
              // Display a ListTile for each medication
              return ListTile(
                onLongPress: () {
                  print('Long press on ${med.name}');
                },
                leading: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: const Icon(Icons.medication)),
                title: Text(
                    '${med.name} - ${med.dose} ${med.unit.toString().split('.').last}'),
                subtitle: Text(medMgr.medications[index].frequency
                    .toString()
                    .split('.')
                    .last),
              );
            },
          ),

          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 176, 121, 187),
            title: const Text("Don't Forget"),
          ),
          // Add the main drawer to the Scaffold
          drawer: const MainAppDrawer(),
        );
      }),
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
            title: const Text('Medication List'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
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
