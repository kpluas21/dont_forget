import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum Frequency {
  daily,
  weekly,
  biweekly,
  monthly,
  quarterly,
  yearly,
  asNeeded,
}

enum MeasurementUnit {
  mg,
  g,
  mL,
  L,
  oz,
}

enum MedicationType {
  capsule,
  tablet,
  patch,
  gummy,
  liquid,
  injection,
  suppository,
}

class Medication {
  MedicationType type;
  Frequency frequency;
  MeasurementUnit unit;

  String name;
  double dose;
  int count = 1;

  String get typeString => type.toString().split('.').last;
  String get frequencyString => frequency.toString().split('.').last;
  String get unitString => unit.toString().split('.').last;

  Medication(
      this.type, this.name, this.frequency, this.unit, this.dose, this.count);

  @override
  String toString() {
    return '$name($typeString) - $count of $dose $unitString taken $frequencyString';
  }

  Map<String, dynamic> toJSON() {
    return {
      'type': typeString,
      'name': name,
      'frequency': frequencyString,
      'unit': unitString,
      'dose': dose,
      'count': count,
    };
  }

  factory Medication.fromJSON(Map<String, dynamic> json) {
    return Medication(
      MedicationType.values.firstWhere(
          (type) => type.toString().split('.').last == json['type']),
      json['name'],
      Frequency.values.firstWhere(
          (freq) => freq.toString().split('.').last == json['frequency']),
      MeasurementUnit.values.firstWhere(
          (unit) => unit.toString().split('.').last == json['unit']),
      json['dose'],
      json['count'] ?? 1,
    );
  }
}

//Saves medications to local storage
Future<void> saveMedications(List<Medication> medications) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> medsJson =
      medications.map((med) => jsonEncode(med.toJSON())).toList();
  await prefs.setStringList('medications', medsJson);
}

//Loads medications from local storage
Future<List<Medication>> loadMedications() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('medications');
  try {
    if (jsonList != null) {
      return jsonList.map((jsonString) {
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return Medication.fromJSON(jsonMap);
      }).toList();
    }
  } on FormatException catch (e) {
    debugPrint('Error loading medications: $e');
  }
  return [];
}

//Helps manage the list of medications
class MedicationProvider with ChangeNotifier {
  final List<Medication> _medications = [];
  List<Medication> get medications => _medications;

  void addMedication(Medication medication) {
    debugPrint('Adding medication: $medication');

    _medications.add(medication);
    saveMedications(medications);

    assert(_medications.contains(medication));

    notifyListeners();
  }

  void removeMedication(Medication medication) {
    debugPrint('Removing medication: $medication');

    _medications.remove(medication);
    saveMedications(medications);
    notifyListeners();
  }

  void updateMedication(Medication oldMed, Medication newMed) {
    debugPrint('Updating medication: $oldMed to $newMed');

    final index = _medications.indexOf(oldMed);
    _medications[index] = newMed;
    saveMedications(medications);
    notifyListeners();
  }

  void listMedications() {
    for (var med in _medications) {
      debugPrint(med.toString());
    }
  }
}
