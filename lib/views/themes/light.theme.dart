import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  primaryColor: Colors.blue,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 230, 230, 230),
    primary: Colors.blue,
    secondary: Colors.blue,
    tertiary: Color.fromARGB(255, 102, 160, 207),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(
      color: Color.fromARGB(255, 29, 29, 29),
    ),
  ),
);
