import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/data_manager/domain/models/export_data.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExportService {
  final AppDatabase _db;

  ExportService(this._db);

  Future<String> exportData({required bool includeImages}) async {
    final accounts = await _db.select(_db.accounts).get();
    final categories = await _db.select(_db.categories).get();
    final transactions = await _db.select(_db.transactions).get();
    final transactionImages = await _db.select(_db.transactionImages).get();
    final starredTransactions = await _db.select(_db.starredTransactions).get();
    final budgets = await _db.select(_db.budgets).get();
    final savingsGoals = await _db.select(_db.savingsGoals).get();
    final savingsContributions = await _db.select(_db.savingsContributions).get();
    final exchangeRates = await _db.select(_db.exchangeRates).get();

    final serializer = driftRuntimeOptions.defaultSerializer;

    List<Map<String, dynamic>> exportImages = [];
    for (final img in transactionImages) {
      final json = img.toJson(serializer: serializer);
      if (includeImages) {
        final file = File(img.localPath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          json['imageBase64'] = base64Encode(bytes);
        }
      }
      exportImages.add(json);
    }

    final Map<String, dynamic> data = {
      'accounts': accounts.map((r) => r.toJson(serializer: serializer)).toList(),
      'categories': categories.map((r) => r.toJson(serializer: serializer)).toList(),
      'transactions': transactions.map((r) => r.toJson(serializer: serializer)).toList(),
      'transactionImages': exportImages,
      'starredTransactions': starredTransactions.map((r) => r.toJson(serializer: serializer)).toList(),
      'budgets': budgets.map((r) => r.toJson(serializer: serializer)).toList(),
      'savingsGoals': savingsGoals.map((r) => r.toJson(serializer: serializer)).toList(),
      'savingsContributions': savingsContributions.map((r) => r.toJson(serializer: serializer)).toList(),
      'exchangeRates': exchangeRates.map((r) => r.toJson(serializer: serializer)).toList(),
    };

    final prefs = await SharedPreferences.getInstance();
    data['settings'] = {
      'themeMode': prefs.getString('settings_theme_mode'),
      'locale': prefs.getString('settings_locale'),
      'currencyCode': prefs.getString('settings_currency_code'),
      'defaultHomeIsCalendar': prefs.getBool('settings_default_home_view'),
      'biometricLogin': prefs.getBool('settings_biometric_login'),
    };

    final exportData = ExportData(
      version: 1,
      exportedAt: DateTime.now(),
      appVersion: '1.0.0',
      hasImages: includeImages,
      data: data,
    );

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData.toJson());

    final exportDir = await _getExportDir();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = p.join(exportDir.path, 'expenselab_backup_$timestamp.json');
    final file = File(filePath);
    await file.writeAsString(jsonString);

    return filePath;
  }

  Future<Directory> _getExportDir() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(baseDir.path, 'ExpenseLab'));
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    return exportDir;
  }

  Future<List<FileSystemEntity>> listBackupFiles() async {
    try {
      final exportDir = await _getExportDir();
      final entities = await exportDir.list().toList();
      entities.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      return entities.whereType<File>().where((f) => f.path.endsWith('.json')).toList();
    } catch (_) {
      return [];
  }
}
}
