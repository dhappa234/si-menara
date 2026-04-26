import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFFF9B00);
  static const Color secondary = Color(0xFFFFE100);
  static const Color accent = Color(0xFFFFC900);
  static const Color background = Color(0xFFEBE389);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
  );
}
