import 'package:expense_lab/core/lang/shared_translations.dart';
import 'package:expense_lab/presentation/modules/accounts/lang/accounts_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

abstract class AppLocales {
  static const english = "en";
  static const spanish = "es";

  static const List<Locale> supportedLocales = [
    Locale(english),
    Locale(spanish),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    AppLocales.english: {
      ...SharedTranslations.keys[AppLocales.english]!,
      ...AccountsTranslations.keys[AppLocales.english]!,
    },
    AppLocales.spanish: {
      ...SharedTranslations.keys[AppLocales.spanish]!,
      ...AccountsTranslations.keys[AppLocales.spanish]!,
    },
  };
}
