import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/savings/data/datasources/savings_goals_local_datasource.dart';
import 'package:expenselab/features/savings/domain/models/savings_goal_model.dart';

/// Mediates access to [SavingsGoalModel] data on behalf of application
/// features.
///
/// Converts Drift-generated [SavingsGoal] entities to [SavingsGoalModel] at
/// the repository boundary so callers never depend on the persistence layer
/// directly. Write operations still accept [SavingsGoalsCompanion] — the
/// database type — because form screens build companions themselves.
///
/// When a remote data source is introduced, add it as a second field here and
/// implement an offline-first (or remote-first) strategy — callers and
/// providers are unaffected because they depend on this class, not on the
/// datasource directly.
class SavingsGoalsRepository {
  const SavingsGoalsRepository(this._local);

  final SavingsGoalsLocalDataSource _local;

  /// Streams all non-deleted savings goals as [SavingsGoalModel],
  /// re-emitting on every database change.
  Stream<List<SavingsGoalModel>> watchAll() =>
      _local.watchAll().map((list) => list.map(SavingsGoalModel.fromSavingsGoal).toList());

  /// Streams a single non-deleted savings goal by [id] as [SavingsGoalModel],
  /// or `null` if not found.
  Stream<SavingsGoalModel?> watchById(String id) =>
      _local.watchById(id).map((g) => g != null ? SavingsGoalModel.fromSavingsGoal(g) : null);

  /// Returns all non-deleted savings goals as a one-shot future.
  Future<List<SavingsGoalModel>> getAll() async =>
      (await _local.getAll()).map(SavingsGoalModel.fromSavingsGoal).toList();

  /// Returns a single non-deleted savings goal by [id], or `null` if not
  /// found.
  Future<SavingsGoalModel?> getById(String id) async {
    final g = await _local.getById(id);
    return g != null ? SavingsGoalModel.fromSavingsGoal(g) : null;
  }

  /// Inserts a new savings goal and returns its generated [id].
  Future<String> create(SavingsGoalsCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the savings goal identified by [id].
  Future<void> update(String id, SavingsGoalsCompanion data) => _local.update(id, data);

  /// Soft-deletes the savings goal identified by [id].
  Future<void> delete(String id) => _local.delete(id);
}
