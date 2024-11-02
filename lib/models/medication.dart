import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum Frequency {
  daily,
  weekly,
  biweekly,
  monthly,
  quarterly,
  yearly,
}

enum MeasurementUnit {
  mg,
  g,
  mL,
  L,
  oz,
}

abstract class Medication {
  String name;
  Frequency frequency;
  MeasurementUnit unit;
  double dose;

  Medication(this.name, this.frequency, this.unit, this.dose);
  Map<String, dynamic> toJSON();
}

class Pill extends Medication {

  Pill(super.name, super.frequency, super.unit, super.dose);

  String getUnit() {
    return unit.toString().split('.').last;
  }

  String getFreq() {
    return frequency.toString().split('.').last;
  }

  @override
  Map<String, dynamic> toJSON() => {
    'type' : 'pill',
    'name' : name,
    'dose' : dose,
    'unit' : unit.toString().split('.').last,
  };
  
  @override
  String toString() => '$name - {$getUnit()}';
}

class Liquid extends Medication {

  Liquid(super.name, super.frequency, super.unit, super.dose);

  @override
  Map<String, dynamic> toJSON() => {
    'type' : 'liquid',
    'name' : name,
    'dose' : dose,
    'unit' : unit.toString().split('.').last,
  };
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
    if (medMap['type'] == 'pill') {
      return Pill(medMap['name'], Frequency.daily, MeasurementUnit.mg, medMap['dose']);
    } else {
      return Liquid(medMap['name'], Frequency.daily, MeasurementUnit.mL, medMap['dose']);
    }
  }).toList();
}