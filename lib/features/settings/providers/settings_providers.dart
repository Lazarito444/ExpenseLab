import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/domain/models/app_settings.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings.fromPrefs(prefs);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final current = state.requireValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_theme_mode', mode.name);
    state = AsyncData(current.copyWith(themeMode: mode));
  }

  Future<void> setLocale(AppLocale locale) async {
    final current = state.requireValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_locale', locale.languageCode);
    LocaleSettings.setLocale(locale);
    state = AsyncData(current.copyWith(locale: locale));
  }

  Future<void> setCurrency(Currency currency) async {
    final current = state.requireValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_currency_code', currency.code);
    state = AsyncData(current.copyWith(currency: currency));
  }

  Future<void> setDefaultHomeView(bool isCalendar) async {
    final current = state.requireValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings_default_home_view', isCalendar);
    state = AsyncData(current.copyWith(defaultHomeIsCalendar: isCalendar));
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).value?.themeMode ?? ThemeMode.system;
});

final currencyProvider = Provider<Currency>((ref) {
  return ref.watch(settingsProvider).value?.currency ?? kUsdCurrency;
});
