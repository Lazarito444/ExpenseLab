import 'package:expenselab/expense_lab_app.dart';
import 'package:expenselab/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  launchExpenseLabApp();
}

void launchExpenseLabApp() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: const ExpenseLabApp(),
      ),
    ),
  );
}
