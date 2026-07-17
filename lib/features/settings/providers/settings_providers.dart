import 'dart:io';

import 'package:expenselab/core/database/database_providers.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/seed/seed_data_provider.dart';
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

  Future<void> setBiometricLogin(bool enabled) async {
    final current = state.requireValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings_biometric_login', enabled);
    state = AsyncData(current.copyWith(biometricLogin: enabled));
  }

  Future<void> eraseAllData() async {
    // 1. Delete physical transaction image files from disk
    try {
      final db = ref.read(appDatabaseProvider);
      final images = await db.select(db.transactionImages).get();
      for (final img in images) {
        if (img.localPath.isNotEmpty) {
          final file = File(img.localPath);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Error deleting transaction image files: $e');
    }

    // 2. Clear all Drift database tables
    try {
      final db = ref.read(appDatabaseProvider);
      await db.transaction(() async {
        await db.delete(db.transactionImages).go();
        await db.delete(db.transactions).go();
        await db.delete(db.starredTransactions).go();
        await db.delete(db.savingsContributions).go();
        await db.delete(db.savingsGoals).go();
        await db.delete(db.budgets).go();
        await db.delete(db.categories).go();
        await db.delete(db.accounts).go();
        await db.delete(db.exchangeRates).go();
      });
    } catch (e) {
      debugPrint('Error clearing database tables: $e');
    }

    // 3. Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 4. Update the settings state
    state = AsyncData(AppSettings.fromPrefs(prefs));

    // 5. Seed default categories and account
    await ref.read(seedDataServiceProvider).seedIfNeeded();
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
