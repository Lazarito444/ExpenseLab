import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/expense_lab_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  launchExpenseLabApp();
}

Future<void> launchExpenseLabApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: const ExpenseLabApp(),
      ),
    ),
  );
}
