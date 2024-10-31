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

  Medication(this.name, this.frequency, this.unit);
  Map<String, dynamic> toJSON();
}

class Pill extends Medication {
  int dose;

  Pill(super.name, super.frequency, super.unit, this.dose);

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
  };
  
  @override
  String toString() => '$name - {$getUnit()}';
}

class Liquid extends Medication {
  double volume;

  Liquid(super.name, super.frequency, super.unit, this.volume);

  @override
  Map<String, dynamic> toJSON() => {
    'type' : 'liquid',
    'name' : name,
    'volume' : volume,
  };
}