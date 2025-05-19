import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF2A3B8F);
  static const Color accent = Color(0xFF00C2A8);
  static const Color background = Color(0xFFF5F7FF);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: accent,
      background: background,
    ),
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}