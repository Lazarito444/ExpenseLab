import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/expense_lab_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  launchExpenseLabApp();
}

Future<void> launchExpenseLabApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('settings_locale');
  final locale = savedLocale != null
      ? AppLocaleUtils.parse(savedLocale)
      : AppLocaleUtils.findDeviceLocale();
  LocaleSettings.setLocale(locale);
  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: const ExpenseLabApp(),
      ),
    ),
  );
}
