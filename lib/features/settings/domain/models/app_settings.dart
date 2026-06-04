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
    required this.defaultHomeIsCalendar,
  });

  final ThemeMode themeMode;
  final AppLocale locale;
  final Currency currency;
  final bool defaultHomeIsCalendar;

  static const _keyTheme = 'settings_theme_mode';
  static const _keyLocale = 'settings_locale';
  static const _keyCurrency = 'settings_currency_code';
  static const _keyDefaultHomeView = 'settings_default_home_view';

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

    final defaultHomeIsCalendar = prefs.getBool(_keyDefaultHomeView) ?? false;

    return AppSettings(
      themeMode: themeMode,
      locale: locale,
      currency: currency,
      defaultHomeIsCalendar: defaultHomeIsCalendar,
    );
  }

  Future<void> saveToPrefs(SharedPreferences prefs) async {
    await prefs.setString(_keyTheme, themeMode.name);
    await prefs.setString(_keyLocale, locale.languageCode);
    await prefs.setString(_keyCurrency, currency.code);
    await prefs.setBool(_keyDefaultHomeView, defaultHomeIsCalendar);
  }

  AppSettings copyWith({
    ThemeMode? themeMode,
    AppLocale? locale,
    Currency? currency,
    bool? defaultHomeIsCalendar,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    locale: locale ?? this.locale,
    currency: currency ?? this.currency,
    defaultHomeIsCalendar: defaultHomeIsCalendar ?? this.defaultHomeIsCalendar,
  );
}
