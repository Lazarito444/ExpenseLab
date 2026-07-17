import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/data_manager/domain/models/export_data.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportService {
  final AppDatabase _db;

  ImportService(this._db);

  Future<ImportSummary> getSummary(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found');
    }

    final jsonStr = await file.readAsString();
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    final exportData = ExportData.fromJson(json);

    if (exportData.version != 1) {
      throw Exception('Unsupported export version: ${exportData.version}');
    }

    final data = exportData.data;

    return ImportSummary(
      accounts: (data['accounts'] as List?)?.length ?? 0,
      categories: (data['categories'] as List?)?.length ?? 0,
      transactions: (data['transactions'] as List?)?.length ?? 0,
      transactionImages: (data['transactionImages'] as List?)?.length ?? 0,
      starredTransactions: (data['starredTransactions'] as List?)?.length ?? 0,
      budgets: (data['budgets'] as List?)?.length ?? 0,
      savingsGoals: (data['savingsGoals'] as List?)?.length ?? 0,
      savingsContributions: (data['savingsContributions'] as List?)?.length ?? 0,
      exchangeRates: (data['exchangeRates'] as List?)?.length ?? 0,
      hasSettings: data.containsKey('settings'),
      hasImages: exportData.hasImages,
    );
  }

  Future<void> importData(String filePath) async {
    final file = File(filePath);
    final jsonStr = await file.readAsString();
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    final exportData = ExportData.fromJson(json);

    if (exportData.version != 1) {
      throw Exception('Unsupported export version: ${exportData.version}');
    }

    final data = exportData.data;

    // 1. Delete physical image files
    try {
      final existingImages = await _db.select(_db.transactionImages).get();
      for (final img in existingImages) {
        if (img.localPath.isNotEmpty) {
          final f = File(img.localPath);
          if (await f.exists()) {
            await f.delete();
          }
        }
      }
    } catch (_) {}

    final serializer = driftRuntimeOptions.defaultSerializer;

    // 2. Clear all tables in reverse FK order
    await _db.transaction(() async {
      await _db.delete(_db.transactionImages).go();
      await _db.delete(_db.transactions).go();
      await _db.delete(_db.starredTransactions).go();
      await _db.delete(_db.savingsContributions).go();
      await _db.delete(_db.savingsGoals).go();
      await _db.delete(_db.budgets).go();
      await _db.delete(_db.categories).go();
      await _db.delete(_db.accounts).go();
      await _db.delete(_db.exchangeRates).go();
    });

    // 3. Import accounts
    final accountsJson = (data['accounts'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    for (final acc in accountsJson) {
      await _db.into(_db.accounts).insert(
        Account.fromJson(acc, serializer: serializer),
      );
    }

    // 4. Import categories (top-level first, then subcategories)
    final allCategories = (data['categories'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final topLevel = allCategories.where((c) => c['parentId'] == null).toList();
    final subCategories = allCategories.where((c) => c['parentId'] != null).toList();
    for (final cat in [...topLevel, ...subCategories]) {
      await _db.into(_db.categories).insert(
        Category.fromJson(cat, serializer: serializer),
      );
    }

    // 5. Import transactions
    final transactionsJson = (data['transactions'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    for (final tx in transactionsJson) {
      await _db.into(_db.transactions).insert(
        Transaction.fromJson(tx, serializer: serializer),
      );
    }

    // 6. Import transaction images
    final imagesJson = (data['transactionImages'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    for (final img in imagesJson) {
      String? imageBase64 = img.remove('imageBase64') as String?;
      await _db.into(_db.transactionImages).insert(
        TransactionImage.fromJson(img, serializer: serializer),
      );
      if (imageBase64 != null) {
        final dir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory(p.join(dir.path, 'receipts'));
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }
        final imgPath = p.join(imagesDir.path, '${img['id']}.jpg');
        final bytes = base64Decode(imageBase64);
        await File(imgPath).writeAsBytes(bytes);
      }
    }

    // 7. Import starred transactions
    final starredJson = (data['starredTransactions'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    for (final st in starredJson) {
      await _db.into(_db.starredTransactions).insert(
        StarredTransaction.fromJson(st, serializer: serializer),
      );
    }

    // 8. Import budgets
    final budgetsJson = (data['budgets'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    for (final bg in budgetsJson) {
      await _db.into(_db.budgets).insert(
        Budget.fromJson(bg, serializer: serializer),
      );
    }

    // 9. Import savings goals
    final goalsJson = (data['savingsGoals'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    for (final goal in goalsJson) {
      await _db.into(_db.savingsGoals).insert(
        SavingsGoal.fromJson(goal, serializer: serializer),
      );
    }

    // 10. Import savings contributions
    final contribsJson = (data['savingsContributions'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    for (final contrib in contribsJson) {
      await _db.into(_db.savingsContributions).insert(
        SavingsContribution.fromJson(contrib, serializer: serializer),
      );
    }

    // 11. Import exchange rates
    final ratesJson = (data['exchangeRates'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    for (final rate in ratesJson) {
      await _db.into(_db.exchangeRates).insert(
        ExchangeRate.fromJson(rate, serializer: serializer),
      );
    }

    // 12. Apply settings
    if (data.containsKey('settings') && data['settings'] is Map<String, dynamic>) {
      final settings = data['settings'] as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();
      if (settings['themeMode'] != null) {
        await prefs.setString('settings_theme_mode', settings['themeMode'] as String);
      }
      if (settings['locale'] != null) {
        await prefs.setString('settings_locale', settings['locale'] as String);
      }
      if (settings['currencyCode'] != null) {
        await prefs.setString('settings_currency_code', settings['currencyCode'] as String);
      }
      if (settings['defaultHomeIsCalendar'] != null) {
        await prefs.setBool('settings_default_home_view', settings['defaultHomeIsCalendar'] as bool);
      }
      if (settings['biometricLogin'] != null) {
        await prefs.setBool('settings_biometric_login', settings['biometricLogin'] as bool);
      }
    }

    // 13. Reset seed flag so default data isn't re-inserted
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('app_seeded', true);
  }
}
