import 'package:expenselab/core/database/database_providers.dart';
import 'package:expenselab/features/data_manager/domain/services/export_service.dart';
import 'package:expenselab/features/data_manager/domain/services/import_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService(ref.watch(appDatabaseProvider));
});

final importServiceProvider = Provider<ImportService>((ref) {
  return ImportService(ref.watch(appDatabaseProvider));
});
