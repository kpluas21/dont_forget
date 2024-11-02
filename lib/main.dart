import 'package:flutter/material.dart';
import 'models/medication.dart';
import 'mock/mock_medications.dart';

final List<Frequency> frequencies = [
  Frequency.daily,
  Frequency.weekly,
  Frequency.biweekly,
  Frequency.monthly,
  Frequency.quarterly,
  Frequency.yearly,
];

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple, brightness: Brightness.light),
      ),
      home: Scaffold(
        // Display the list of medications
        body: ListView.builder(
          itemCount: medications.length,
          itemBuilder: (context, index) {
            final med = medications[index];
            return ListTile(
              onLongPress: () {
                print('Long press on ${med.name}');
              },
              leading: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: const Icon(Icons.medication)),
              title: Text(
                  '${med.name} - ${med.dose} ${med.unit.toString().split('.').last}'),
              subtitle:
                  Text(medications[index].frequency.toString().split('.').last),
            );
          },
        ),

        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 176, 121, 187),
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
            title: const Text('Medication List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainApp()),
              );
            },
          ),
          ListTile(
            title: const Text('Add New Medication'),
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
class MedicationEntry extends StatefulWidget {
  const MedicationEntry({super.key});

  @override
  State<MedicationEntry> createState() => _MedicationEntryState();
}

class _MedicationEntryState extends State<MedicationEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = '';
  String _dose = '';

  Frequency dropdownValue = frequencies[0];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Name: $_name, Dose: $_dose');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry'),
      ),
      body: newMedicationForm(),
      drawer: const MainAppDrawer(),
    );
  }

  Form newMedicationForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Dose'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a dose';
                }
                return null;
              },
              onSaved: (value) {
                _dose = value!;
              },
            ),
            DropdownButton<Frequency>(
              value: dropdownValue,
              onChanged: (Frequency? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: frequencies
                  .map((Frequency freq) => DropdownMenuItem<Frequency>(
                        value: freq,
                        child: Text(freq.toString().split('.').last),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
