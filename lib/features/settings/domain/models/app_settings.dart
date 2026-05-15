import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.locale,
    required this.currency,
  });

  final ThemeMode themeMode;
  final AppLocale locale;
  final Currency currency;

  static const _keyTheme = 'settings_theme_mode';
  static const _keyLocale = 'settings_locale';
  static const _keyCurrency = 'settings_currency_code';

  static AppSettings fromPrefs(SharedPreferences prefs) {
    final themeMode = switch (prefs.getString(_keyTheme)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    final localeTag = prefs.getString(_keyLocale);
    final locale = localeTag != null ? AppLocaleUtils.parse(localeTag) : AppLocale.en;

    final currencyCode = prefs.getString(_keyCurrency);
    final currency = currencyCode != null
        ? kSupportedCurrencies.firstWhere(
            (c) => c.code == currencyCode,
            orElse: () => kUsdCurrency,
          )
        : kUsdCurrency;

    return AppSettings(themeMode: themeMode, locale: locale, currency: currency);
  }

  Future<void> saveToPrefs(SharedPreferences prefs) async {
    await prefs.setString(_keyTheme, themeMode.name);
    await prefs.setString(_keyLocale, locale.languageCode);
    await prefs.setString(_keyCurrency, currency.code);
  }

  AppSettings copyWith({
    ThemeMode? themeMode,
    AppLocale? locale,
    Currency? currency,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    locale: locale ?? this.locale,
    currency: currency ?? this.currency,
  );
}
