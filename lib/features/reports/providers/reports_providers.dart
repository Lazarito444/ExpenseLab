import 'package:expenselab/core/database/database_providers.dart';
import 'package:expenselab/features/budgets/providers/budgets_providers.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/features/reports/data/datasources/reports_local_datasource.dart';
import 'package:expenselab/features/reports/data/datasources/reports_local_datasource_impl.dart';
import 'package:expenselab/features/reports/data/repositories/reports_repository.dart';
import 'package:expenselab/features/reports/domain/models/report_model.dart';
import 'package:expenselab/features/reports/domain/services/report_generator_service.dart';
import 'package:expenselab/features/savings/providers/savings_providers.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportsLocalDataSourceProvider = Provider<ReportsLocalDataSource>((ref) {
  return ReportsLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(ref.watch(reportsLocalDataSourceProvider));
});

final reportsProvider = StreamProvider<List<ReportModel>>((ref) {
  return ref.watch(reportsRepositoryProvider).watchAll();
});

final reportByIdProvider = StreamProvider.family<ReportModel?, String>((ref, id) {
  return ref.watch(reportsRepositoryProvider).watchById(id);
});

final reportGeneratorServiceProvider = Provider<ReportGeneratorService>((ref) {
  final txs = ref.watch(visibleTransactionsProvider);
  final catsAsync = ref.watch(categoriesProvider);
  final budgetsAsync = ref.watch(budgetsProvider);
  final goalsAsync = ref.watch(savingsGoalsProvider);
  final contribsAsync = ref.watch(savingsContributionsProvider);

  final cats = catsAsync.asData?.value ?? [];
  final budgets = budgetsAsync.asData?.value ?? [];
  final goals = goalsAsync.asData?.value ?? [];
  final contribs = contribsAsync.asData?.value ?? [];

  return ReportGeneratorService(
    reportsDataSource: ref.watch(reportsLocalDataSourceProvider),
    allTransactions: txs,
    allCategories: cats,
    allBudgets: budgets,
    allSavingsGoals: goals,
    allContributions: contribs,
  );
});

final ensureLastMonthReportProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(reportGeneratorServiceProvider);
  await service.ensureReportForLastMonth();
});

final reportDataProvider = FutureProvider.family<ReportData?, String>((ref, reportId) async {
  final reportAsync = ref.watch(reportByIdProvider(reportId));
  final report = reportAsync.asData?.value;
  if (report == null) return null;
  final service = ref.watch(reportGeneratorServiceProvider);
  return service.buildReportData(report.year, report.month);
});
