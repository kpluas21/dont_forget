import 'package:dont_forget/main.dart';
import 'package:dont_forget/main_app_drawer.dart';
import 'package:dont_forget/models/medication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dont_forget/util/confirm_dialog.dart';

class MedicationEntry extends StatefulWidget {
  final Medication? existingMed;

  const MedicationEntry({super.key, this.existingMed, required this.onAdd});

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
  String _count = '1';

  late MedicationType typeValue;
  late Frequency frequencyValue;
  late MeasurementUnit unitValue;

  // Initialize the form with the existing medication values if they exist
  @override
  void initState() {
    super.initState();
    if (widget.existingMed != null) {
      typeValue = widget.existingMed!.type;
      frequencyValue = widget.existingMed!.frequency;
      unitValue = widget.existingMed!.unit;
      _name = widget.existingMed!.name;
      _dose = widget.existingMed!.dose.toString();
      _count = widget.existingMed!.count.toString();
    } else {
      //Establish default values
      typeValue = types[0];
      frequencyValue = frequencies[0];
      unitValue = units[0];
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.existingMed != null) {
        widget.existingMed!.name = _name;
        widget.existingMed!.dose = double.parse(_dose);
        widget.existingMed!.count = int.parse(_count);
        widget.existingMed!.type = typeValue;
        widget.existingMed!.frequency = frequencyValue;
        widget.existingMed!.unit = unitValue;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medication updated')),
        );
        Navigator.pop(context);
      }
      newMed = Medication(
        typeValue,
        _name,
        frequencyValue,
        unitValue,
        double.parse(_dose),
        int.parse(_count),
      );

      if (kDebugMode) {
        print(newMed.toString());
      }

      widget.onAdd(newMed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medication added')),
      );

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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
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
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Count'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a count';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _count = value!;
                    },
                  ),
                ),
              ],
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
              onPressed: () {
                showConfirmDialog(
                    context, _submitForm, 'Are you sure you want to submit?');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
