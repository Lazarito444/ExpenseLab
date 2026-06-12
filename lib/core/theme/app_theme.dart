import 'package:expenselab/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color seedColor = Color(0xFF2D6831);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: seedColor,
      primary: seedColor,
      primaryFixed: const Color(0xFF4E8A4F),
      secondaryContainer: Colors.white,
      scrim: Colors.grey.shade900,
      outline: const Color(0xFF508952),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D6831),
        fontSize: 20,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1.2,
        color: Color(0xFF9EAEA2),
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F1E36),
        fontSize: 32,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F1E36),
        fontSize: 18,
      ),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F8F8),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: seedColor);
        }
        return IconThemeData(color: Colors.grey.shade700);
      }),
    ),
    extensions: const [AppColors.light],
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      primary: const Color(0xFF6DBF6F),
      primaryFixed: const Color(0xFF4E8A4F),
      secondaryContainer: const Color(0xFF1E2420),
      scrim: Colors.white,
      outline: const Color(0xFF7BAD7C),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w600,
        color: Color(0xFF6DBF6F),
        fontSize: 20,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1.2,
        color: Color(0x61FFFFFF),
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 32,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 18,
      ),
    ),
    scaffoldBackgroundColor: const Color(0xFF171B18),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E2420),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: Color(0xFF6DBF6F));
        }
        return const IconThemeData(color: Color(0xFF9E9E9E));
      }),
    ),
    extensions: const [AppColors.dark],
  );
}
