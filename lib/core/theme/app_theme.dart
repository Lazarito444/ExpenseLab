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
        color: Colors.black,
        fontSize: 32,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
        fontSize: 18,
      ),
      // labelSmall: TextStyle(
      //   fontFamily: 'Epilogue',
      //   fontWeight: FontWeight.w500,
      //   color: Color(0xFFD3E6CF),
      //   fontSize: 16,
      // ),
      // displayMedium: TextStyle(
      //   fontFamily: 'Epilogue',
      //   fontWeight: FontWeight.w600,
      //   color: Colors.white,
      //   fontSize: 34,
      // ),
      // labelMedium: TextStyle(
      //   fontFamily: 'Epilogue',
      //   fontWeight: FontWeight.w700,
      //   color: Color(0xFFD3E6CF),
      //   fontSize: 15,
      // ),
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
