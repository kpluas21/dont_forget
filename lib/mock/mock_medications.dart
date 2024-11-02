import '../models/medication.dart';

List<Medication> getMockMedications() {
  return [
    Medication(
      MedicationType.tablet,
      'Aspirin',
      Frequency.daily,
      MeasurementUnit.mg,
      325,
      1
    ),
    Medication(
      MedicationType.tablet,
      'Lisinopril',
      Frequency.monthly,
      MeasurementUnit.mg,
      10,
      1
    ),
    Medication(
      MedicationType.tablet,
      'Atorvastatin',
      Frequency.quarterly,
      MeasurementUnit.mg,
      20,
      1
    ),
    Medication(
      MedicationType.liquid,
      'Lantus',
      Frequency.biweekly,
      MeasurementUnit.mL,
      10,
      1
    ),
    Medication(
      MedicationType.injection,
      'Humalog',
      Frequency.weekly,
      MeasurementUnit.mL,
      5,
      1
    ),
  ];
}