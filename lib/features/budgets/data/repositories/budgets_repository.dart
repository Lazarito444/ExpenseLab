import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/budgets/data/datasources/budgets_local_datasource.dart';
import 'package:expenselab/features/budgets/domain/models/budget_model.dart';

/// Mediates access to [BudgetModel] data on behalf of application features.
///
/// Converts Drift-generated [Budget] entities to [BudgetModel] at the
/// repository boundary so callers never depend on the persistence layer
/// directly. Write operations still accept [BudgetsCompanion] — the database
/// type — because form screens build companions themselves.
///
/// When a remote data source is introduced, add it as a second field here and
/// implement an offline-first (or remote-first) strategy — callers and
/// providers are unaffected because they depend on this class, not on the
/// datasource directly.
class BudgetsRepository {
  const BudgetsRepository(this._local);

  final BudgetsLocalDataSource _local;

  /// Streams all non-deleted budgets as [BudgetModel], re-emitting on every
  /// database change.
  Stream<List<BudgetModel>> watchAll() =>
      _local.watchAll().map((list) => list.map(BudgetModel.fromBudget).toList());

  /// Streams a single non-deleted budget by [id] as [BudgetModel], or `null`
  /// if not found.
  Stream<BudgetModel?> watchById(String id) =>
      _local.watchById(id).map((b) => b != null ? BudgetModel.fromBudget(b) : null);

  /// Returns all non-deleted budgets as a one-shot future.
  Future<List<BudgetModel>> getAll() async =>
      (await _local.getAll()).map(BudgetModel.fromBudget).toList();

  /// Returns a single non-deleted budget by [id], or `null` if not found.
  Future<BudgetModel?> getById(String id) async {
    final b = await _local.getById(id);
    return b != null ? BudgetModel.fromBudget(b) : null;
  }

  /// Streams all non-deleted budgets for [categoryId] as [BudgetModel],
  /// re-emitting on every change.
  Stream<List<BudgetModel>> watchByCategoryId(String categoryId) =>
      _local.watchByCategoryId(categoryId).map(
        (list) => list.map(BudgetModel.fromBudget).toList(),
      );

  /// Inserts a new budget and returns its generated [id].
  Future<String> create(BudgetsCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the budget identified by [id].
  Future<void> update(String id, BudgetsCompanion data) => _local.update(id, data);

  /// Soft-deletes the budget identified by [id].
  Future<void> delete(String id) => _local.delete(id);
}
