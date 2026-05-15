import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color seedColor = Color(0xFF2E7D32);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      primary: const Color(0xFF2D6831),
      primaryFixed: const Color(0xFF4E8A4F),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D6831),
        fontSize: 24,
      ),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9F8),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ),
  );
}
