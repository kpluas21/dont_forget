import 'package:dont_forget/main.dart';
import 'package:dont_forget/models/medication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
