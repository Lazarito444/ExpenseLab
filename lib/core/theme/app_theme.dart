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
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D6831),
        fontSize: 20,
      ),
      // headlineLarge: TextStyle(
      //   fontFamily: 'Epilogue',
      //   fontWeight: FontWeight.w600,
      //   color: Colors.black,
      //   fontSize: 30,
      // ),
      // headlineSmall: TextStyle(
      //   fontFamily: 'Epilogue',
      //   fontWeight: FontWeight.w400,
      //   color: Color(0xFF474f45),
      //   fontSize: 15,
      // ),
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
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: seedColor, fontFamily: 'Epilogue', fontWeight: FontWeight.bold);
        }
        return TextStyle(color: Colors.grey.shade700, fontFamily: 'Epilogue');
      }),
      // Color del ícono según el estado
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
