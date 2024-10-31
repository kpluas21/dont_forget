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
      Frequency.daily,
      MeasurementUnit.mg,
      10,
    ),
    Pill(
      'Atorvastatin',
      Frequency.daily,
      MeasurementUnit.mg,
      20,
    ),
    Liquid(
      'Lantus',
      Frequency.daily,
      MeasurementUnit.mL,
      10,
    ),
    Liquid(
      'Humalog',
      Frequency.daily,
      MeasurementUnit.mL,
      5,
    ),
  ];
}