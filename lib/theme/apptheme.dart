import 'package:flutter/material.dart';

Color mainAppColor = const Color.fromARGB(255, 61, 110, 202);
Color secondaryAppColor = const Color.fromARGB(255, 109, 107, 209);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
  ),
  appBarTheme: AppBarTheme(
    color: mainAppColor,
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: mainAppColor,
  ),
);

ThemeData darkTheme = ThemeData(
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.red,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.red,
    brightness: Brightness.dark,
  ),
);
