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

//The page for entering a new medication
class MedicationEntry extends StatefulWidget {
  const MedicationEntry({super.key, required this.onAdd});

  final Function(Medication) onAdd;

  @override
  State<MedicationEntry> createState() => _MedicationEntryState();
}

// The state for the MedicationEntry widget
class _MedicationEntryState extends State<MedicationEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Medication newMed;

  String _name = '';
  String _dose = '';

  MedicationType typeValue = types[0];
  Frequency frequencyValue = frequencies[0];
  MeasurementUnit unitValue = units[0];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      newMed = Medication(
        typeValue,
        _name,
        frequencyValue,
        unitValue,
        double.parse(_dose),
        1,
      );

      print(newMed.toString());
      saveMedications(medMgr.medications);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medication added')),
      );

      widget.onAdd(newMed);
      Navigator.pop(context);
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
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
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
            Row(
              children: [
                Padding(padding: const EdgeInsets.all(16.0)),
                // Unit dropdown
                DropdownButton<MeasurementUnit>(
                  value: unitValue,
                  onChanged: (MeasurementUnit? value) {
                    setState(() {
                      unitValue = value!;
                    });
                  },
                  items: MeasurementUnit.values
                      .map((MeasurementUnit unit) =>
                          DropdownMenuItem<MeasurementUnit>(
                            value: unit,
                            child: Text(unit.toString().split('.').last),
                          ))
                      .toList(),
                ),
                // Frequency dropdown
                DropdownButton<Frequency>(
                  value: frequencyValue,
                  onChanged: (Frequency? value) {
                    setState(() {
                      frequencyValue = value!;
                    });
                  },
                  items: frequencies
                      .map((Frequency freq) => DropdownMenuItem<Frequency>(
                            value: freq,
                            child: Text(freq.toString().split('.').last),
                          ))
                      .toList(),
                ),
                // Type dropdown
                DropdownButton(
                  value: typeValue,
                  onChanged: (MedicationType? value) {
                    setState(() {
                      typeValue = value!;
                    });
                  },
                  items: types
                      .map((MedicationType type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.toString().split('.').last),
                          ))
                      .toList(),
                ),
              ],
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
