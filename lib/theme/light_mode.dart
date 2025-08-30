import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade100,   // soft background
    primary: Colors.lightBlue.shade600, // main blue
    secondary: const Color(0xC4D7F8FF), // accent shade
    tertiary: Colors.white, // cards & containers
    inversePrimary: Colors.blueGrey.shade900, // contrast for text/icons
  ),
);