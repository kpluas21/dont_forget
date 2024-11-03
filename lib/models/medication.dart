import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../mock/mock_medications.dart';

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

  Medication(this.type, this.name, this.frequency, this.unit, this.dose, this.count);
  
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
}

//Saves medications to local storage
Future<void> saveMedications(List<Medication> medications) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> medsJson = medications.map((med) => med.toJSON().toString()).toList();
  await prefs.setStringList('medications', medsJson);
}

//Loads medications from local storage
Future<List<Medication>> loadMedications() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> medsJson = prefs.getStringList('medications') ?? [];
  return medsJson.map((medJson) {
    Map<String, dynamic> medMap = jsonDecode(medJson);
    return Medication(
      MedicationType.values.firstWhere((type) => type.toString().split('.').last == medMap['type']),
      medMap['name'],
      Frequency.values.firstWhere((freq) => freq.toString().split('.').last == medMap['frequency']),
      MeasurementUnit.values.firstWhere((unit) => unit.toString().split('.').last == medMap['unit']),
      medMap['dose'],
      medMap['count'],
    );
  }).toList();
}

//Helps manage the list of medications
class MedicationProvider with ChangeNotifier {
  final List<Medication> _medications = [];
  List<Medication> get medications => _medications;



  void addMedication(Medication medication) {
    debugPrint('Adding medication: $medication');
    _medications.add(medication);
    assert (_medications.contains(medication));
    notifyListeners();
  }

  void removeMedication(Medication medication) {
    debugPrint('Removing medication: $medication');
    _medications.remove(medication);
    notifyListeners();
  }

  void listMedications() {
    for (var med in _medications) {
      debugPrint(med.toString());
    }
  }
}