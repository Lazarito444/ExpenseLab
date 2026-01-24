import 'package:expense_lab/core/lang/app_translations.dart';
import 'package:expense_lab/core/theme/app_theme.dart';
import 'package:expense_lab/presentation/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Expense Lab",
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      theme: AppTheme.light().themeData,
      darkTheme: AppTheme.dark().themeData,
      themeMode: ThemeMode.system,
      supportedLocales: AppLocales.supportedLocales,
      localizationsDelegates: AppLocales.localizationDelegates,
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
    );
  }
}
