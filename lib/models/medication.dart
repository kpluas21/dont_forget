import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

/// An enumeration of the different dosage frequencies.
enum Frequency {
  daily,
  weekly,
  biweekly,
  monthly,
  quarterly,
  yearly,
  asNeeded;

  String get displayString {
    switch (this) {
      case Frequency.daily:
        return 'Daily';
      case Frequency.weekly:
        return 'Weekly';
      case Frequency.biweekly:
        return 'Biweekly';
      case Frequency.monthly:
        return 'Monthly';
      case Frequency.quarterly:
        return 'Quarterly';
      case Frequency.yearly:
        return 'Yearly';
      case Frequency.asNeeded:
        return 'As Needed';
    }
  }
}

/// An enumeration of the different units of measurement.
enum MeasurementUnit {
  mg,
  g,
  mL,
  L,
  oz;

  String get displayString {
    switch (this) {
      case MeasurementUnit.mg:
        return 'mg';
      case MeasurementUnit.g:
        return 'g';
      case MeasurementUnit.mL:
        return 'mL';
      case MeasurementUnit.L:
        return 'L';
      case MeasurementUnit.oz:
        return 'oz';
    }
  }
}

/// An enumeration of the different types of medications.
enum MedicationType {
  capsule,
  tablet,
  patch,
  gummy,
  liquid,
  injection,
  suppository;

  String get displayString {
    switch (this) {
      case MedicationType.capsule:
        return 'Capsule';
      case MedicationType.tablet:
        return 'Tablet';
      case MedicationType.patch:
        return 'Patch';
      case MedicationType.gummy:
        return 'Gummy';
      case MedicationType.liquid:
        return 'Liquid';
      case MedicationType.injection:
        return 'Injection';
      case MedicationType.suppository:
        return 'Suppository';
    }
  }
}

final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

/// A class representing a medication.
///
/// This class is used to store information about a medication,
/// including its name, dosage, and any other relevant details.
class Medication {
  MedicationType type;
  Frequency frequency;
  MeasurementUnit unit;

  //When the next reminder is due
  DateTime? nextReminderDate;

  String name;
  double dose;
  int count = 1;
  int? notificationId;
  int? nextNotificationId;

  String get nextReminderDateString => nextReminderDate != null
      ? formatter.format(nextReminderDate!)
      : 'No reminder set';

  Medication(this.type, this.name, this.frequency, this.unit, this.dose,
      this.count, this.nextReminderDate, this.notificationId);

  @override
  String toString() {
    return '$name(${type.displayString}) - $count of $dose ${unit.displayString} taken ${frequency.displayString} - Next reminder at $nextReminderDate';
  }

  Map<String, dynamic> toJSON() {
    return {
      'type': type.displayString,
      'name': name,
      'frequency': frequency.displayString,
      'unit': unit.displayString,
      'dose': dose,
      'count': count,
      'nextReminderDate': nextReminderDate?.toIso8601String(),
      'notificationId': notificationId,
    };
  }

  factory Medication.fromJSON(Map<String, dynamic> json) {
    return Medication(
      MedicationType.values.firstWhere(
          (type) => type.displayString == json['type']),
      json['name'],
      Frequency.values.firstWhere(
          (freq) => freq.displayString == json['frequency']),
      MeasurementUnit.values.firstWhere(
          (unit) => unit.displayString == json['unit']),
      json['dose'],
      json['count'] ?? 1,
      json['nextReminderDate'] != null
          ? DateTime.parse(json['nextReminderDate'])
          : null,
      json['notificationId'],
    );
  }
}

///Saves medications to local storage
Future<void> saveMedications(List<Medication> medications) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> medsJson =
      medications.map((med) => jsonEncode(med.toJSON())).toList();
  await prefs.setStringList('medications', medsJson);
}

///Loads medications from local storage
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

///A provider class for managing medications
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
