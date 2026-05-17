import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/savings/data/datasources/savings_goals_local_datasource.dart';

/// Mediates access to [SavingsGoal] data on behalf of application features.
///
/// Currently delegates all operations to [SavingsGoalsLocalDataSource]. When a
/// remote data source is introduced, add it as a second field here and
/// implement an offline-first (or remote-first) strategy — callers and
/// providers are unaffected because they depend on this class, not on the
/// datasource directly.
class SavingsGoalsRepository {
  const SavingsGoalsRepository(this._local);

  final SavingsGoalsLocalDataSource _local;

  /// Streams all non-deleted savings goals, re-emitting on every database
  /// change.
  Stream<List<SavingsGoal>> watchAll() => _local.watchAll();

  /// Streams a single non-deleted savings goal by [id], or `null` if not
  /// found.
  Stream<SavingsGoal?> watchById(String id) => _local.watchById(id);

  /// Returns all non-deleted savings goals as a one-shot future.
  Future<List<SavingsGoal>> getAll() => _local.getAll();

  /// Returns a single non-deleted savings goal by [id], or `null` if not
  /// found.
  Future<SavingsGoal?> getById(String id) => _local.getById(id);

  /// Inserts a new savings goal and returns its generated [id].
  Future<String> create(SavingsGoalsCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the savings goal identified by [id].
  Future<void> update(String id, SavingsGoalsCompanion data) => _local.update(id, data);

  /// Soft-deletes the savings goal identified by [id].
  Future<void> delete(String id) => _local.delete(id);
}
