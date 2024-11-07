// This file contains helper functions that are used throughout the app

/// Get the string value of an enum
String getEnumValueString(dynamic enumValue) {
  return enumValue.toString().split('.').last;
}