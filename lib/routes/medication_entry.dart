import 'package:dont_forget/models/medication.dart';
import 'package:dont_forget/util/helper_funcs.dart';
import 'package:dont_forget/util/notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dont_forget/util/confirm_dialog.dart';
import 'package:dont_forget/util/text_input.dart';

//Lists of possible values for medication properties
final List<Frequency> frequencies = Frequency.values;
final List<MeasurementUnit> units = MeasurementUnit.values;
final List<MedicationType> types = MedicationType.values;

class MedicationEntry extends StatefulWidget {
  final Medication? existingMed;

  const MedicationEntry({
    super.key,
    this.existingMed,
    required this.onAdd,
    required this.onUpdate,
  });

  final Function(Medication) onAdd;
  final Function(Medication, Medication) onUpdate;

  @override
  State<MedicationEntry> createState() => _MedicationEntryState();
}

// The state for the MedicationEntry widget
class _MedicationEntryState extends State<MedicationEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // The new medication object to be created
  late Medication newMed;

  //The variables to hold the form values
  String _name = '';
  String _dose = '';
  String _count = '1';
  late MedicationType typeValue;
  late Frequency frequencyValue;
  late MeasurementUnit unitValue;

  bool toBeReminded = false;
  DateTime? startDate = DateTime.now();
  DateTime? scheduledTime;

  // Initialize the form with the existing medication values if they exist
  @override
  void initState() {
    super.initState();
    // If an existing medication is passed in, set the form values to the existing values
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

      newMed = Medication(
        typeValue,
        _name,
        frequencyValue,
        unitValue,
        double.parse(_dose),
        int.parse(_count),
        scheduledTime,
      );

      if (widget.existingMed != null) {
        if (kDebugMode) {
          print(
              "Updating medication: ${widget.existingMed!.toString()} to ${newMed.toString()}");
        }
        widget.onUpdate(widget.existingMed!, newMed);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medication updated')),
        );
        Navigator.pop(context);
      } else {
        if (kDebugMode) {
          print(newMed.toString());
        }

        if (scheduledTime != null) {
          // Schedule the notification
          LocalNotificationService().scheduleNotificationAndroid(
              0,
              "Don't Forget",
              "It's time to take your scheduled medication!",
              scheduledTime!);
        }

        widget.onAdd(newMed);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medication added')),
        );

        Navigator.pop(context);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    scheduledTime = await showDatePicker(
      context: context,
      initialDate: startDate!,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 176, 121, 187),
        title: const Text('Medication Editor'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: newMedicationForm(),
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
              textCapitalization: TextCapitalization.words,
              initialValue: _name,
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
            const SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IntFormField(
                    initialValue: _count,
                    labelText: 'Count',
                    onSaved: (value) {
                      _count = value!;
                    }),
                const Padding(padding: EdgeInsets.all(16.0)),
                IntFormField(
                  initialValue: _dose,
                  labelText: 'Dose',
                  onSaved: (value) {
                    _dose = value!;
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                            child: Text(getEnumValueString(unit)),
                          ))
                      .toList(),
                ),
                Padding(padding: const EdgeInsets.all(16.0)),
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
                            child: Text(getEnumValueString(freq)),
                          ))
                      .toList(),
                ),
                Padding(padding: const EdgeInsets.all(16.0)),
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
                            child: Text(getEnumValueString(type)),
                          ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Remind Me!')),
                ElevatedButton(
                  onPressed: () {
                    showConfirmDialog(context, _submitForm,
                        'Are you sure you want to add this new medication?');
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
