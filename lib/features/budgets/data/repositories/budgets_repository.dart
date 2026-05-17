import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/budgets/data/datasources/budgets_local_datasource.dart';

/// Mediates access to [Budget] data on behalf of application features.
///
/// Currently delegates all operations to [BudgetsLocalDataSource]. When a
/// remote data source is introduced, add it as a second field here and
/// implement an offline-first (or remote-first) strategy — callers and
/// providers are unaffected because they depend on this class, not on the
/// datasource directly.
class BudgetsRepository {
  const BudgetsRepository(this._local);

  final BudgetsLocalDataSource _local;

  /// Streams all non-deleted budgets, re-emitting on every database change.
  Stream<List<Budget>> watchAll() => _local.watchAll();

  /// Streams a single non-deleted budget by [id], or `null` if not found.
  Stream<Budget?> watchById(String id) => _local.watchById(id);

  /// Returns all non-deleted budgets as a one-shot future.
  Future<List<Budget>> getAll() => _local.getAll();

  /// Returns a single non-deleted budget by [id], or `null` if not found.
  Future<Budget?> getById(String id) => _local.getById(id);

  /// Streams all non-deleted budgets for [categoryId], re-emitting on every
  /// change.
  Stream<List<Budget>> watchByCategoryId(String categoryId) => _local.watchByCategoryId(categoryId);

  /// Inserts a new budget and returns its generated [id].
  Future<String> create(BudgetsCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the budget identified by [id].
  Future<void> update(String id, BudgetsCompanion data) => _local.update(id, data);

  /// Soft-deletes the budget identified by [id].
  Future<void> delete(String id) => _local.delete(id);
}
