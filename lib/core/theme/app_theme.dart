import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color success;
  final Color info;
  final Color warning;
  final Color error;
  final Color surface;
  final Color onSurface;

  const AppTheme({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.success,
    required this.info,
    required this.warning,
    required this.error,
    required this.surface,
    required this.onSurface,
  });

  factory AppTheme.light() {
    return const AppTheme(
      brightness: Brightness.light,
      primary: Color(0xFF0055FF),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF6C757D),
      onSecondary: Color(0xFFFFFFFF),
      success: Color(0xFF28A745),
      info: Color(0xFF17A2B8),
      warning: Color(0xFFD4AF37),
      error: Color(0xFFDC3545),
      surface: Color(0xFFF4F4F9),
      onSurface: Color(0xFF121212),
    );
  }

  factory AppTheme.dark() {
    return const AppTheme(
      brightness: Brightness.dark,
      primary: Color(0xFF2D8CFF),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFADB5BD),
      onSecondary: Color(0xFF121212),
      success: Color(0xFF43D767),
      info: Color(0xFF17A2B8),
      warning: Color(0xFFD4AF37),
      error: Color(0xFFFF5C5C),
      surface: Color(0xFF0A0B10),
      onSurface: Color(0xFFFFFFFF),
    );
  }

  // El Mapper a ThemeData
  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
    ),
    scaffoldBackgroundColor: surface,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: onSurface,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: brightness == Brightness.dark ? const Color(0xFF11141D) : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: brightness == Brightness.dark ? BorderSide(color: Colors.white.withValues(alpha: 0.05)) : BorderSide.none,
      ),
    ),
  );
}
