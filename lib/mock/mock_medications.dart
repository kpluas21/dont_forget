import '../models/medication.dart';

List<Medication> getMockMedications() {
  return [
    Pill(
      'Aspirin',
      Frequency.daily,
      MeasurementUnit.mg,
      325,
    ),
    Pill(
      'Lisinopril',
      Frequency.monthly,
      MeasurementUnit.mg,
      10,
    ),
    Pill(
      'Atorvastatin',
      Frequency.quarterly,
      MeasurementUnit.mg,
      20,
    ),
    Liquid(
      'Lantus',
      Frequency.biweekly,
      MeasurementUnit.mL,
      10,
    ),
    Liquid(
      'Humalog',
      Frequency.weekly,
      MeasurementUnit.mL,
      5,
    ),
  ];
}