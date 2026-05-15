import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/database/database_providers.dart';
import 'package:expenselab/features/budgets/data/datasources/budgets_local_datasource.dart';
import 'package:expenselab/features/budgets/data/datasources/budgets_local_datasource_impl.dart';
import 'package:expenselab/features/budgets/data/repositories/budgets_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides [BudgetsLocalDataSourceImpl] bound to the [BudgetsLocalDataSource]
/// interface. Swap the implementation here to change the storage backend
/// without touching any repository or UI code.
final budgetsLocalDataSourceProvider = Provider<BudgetsLocalDataSource>((ref) {
  return BudgetsLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

/// Provides the singleton [BudgetsRepository], wired to
/// [budgetsLocalDataSourceProvider].
final budgetsRepositoryProvider = Provider<BudgetsRepository>((ref) {
  return BudgetsRepository(ref.watch(budgetsLocalDataSourceProvider));
});

/// Streams all non-deleted [Budget] records. Automatically re-emits whenever
/// the underlying table changes.
///
/// Usage: `ref.watch(budgetsProvider)` returns `AsyncValue<List<Budget>>`.
final budgetsProvider = StreamProvider<List<Budget>>((ref) {
  return ref.watch(budgetsRepositoryProvider).watchAll();
});

/// Streams a single [Budget] by [id], or `null` if not found or soft-deleted.
/// Re-emits whenever the record changes.
final budgetByIdProvider = StreamProvider.family<Budget?, String>((ref, id) {
  return ref.watch(budgetsRepositoryProvider).watchById(id);
});

/// Streams all non-deleted budgets for [categoryId]. Re-emits on every change.
///
/// Usage: `ref.watch(budgetsByCategoryProvider('category-id'))`.
final budgetsByCategoryProvider = StreamProvider.family<List<Budget>, String>((ref, categoryId) {
  return ref.watch(budgetsRepositoryProvider).watchByCategoryId(categoryId);
});
