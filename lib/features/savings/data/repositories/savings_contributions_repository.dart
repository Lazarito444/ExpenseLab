import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/savings/data/datasources/savings_contributions_local_datasource.dart';

/// Mediates access to [SavingsContribution] data on behalf of application
/// features.
///
/// Currently delegates all operations to [SavingsContributionsLocalDataSource].
/// When a remote data source is introduced, add it as a second field here and
/// implement an offline-first (or remote-first) strategy — callers and
/// providers are unaffected because they depend on this class, not on the
/// datasource directly.
class SavingsContributionsRepository {
  const SavingsContributionsRepository(this._local);

  final SavingsContributionsLocalDataSource _local;

  /// Streams all non-deleted contributions, re-emitting on every database
  /// change.
  Stream<List<SavingsContribution>> watchAll() => _local.watchAll();

  /// Streams a single non-deleted contribution by [id], or `null` if not
  /// found.
  Stream<SavingsContribution?> watchById(String id) => _local.watchById(id);

  /// Returns all non-deleted contributions as a one-shot future.
  Future<List<SavingsContribution>> getAll() => _local.getAll();

  /// Returns a single non-deleted contribution by [id], or `null` if not
  /// found.
  Future<SavingsContribution?> getById(String id) => _local.getById(id);

  /// Streams all non-deleted contributions for [savingsGoalId], re-emitting on
  /// every change.
  Stream<List<SavingsContribution>> watchByGoalId(String savingsGoalId) =>
      _local.watchByGoalId(savingsGoalId);

  /// Inserts a new contribution and returns its generated [id].
  Future<String> create(SavingsContributionsCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the contribution identified by [id].
  Future<void> update(String id, SavingsContributionsCompanion data) =>
      _local.update(id, data);

  /// Soft-deletes the contribution identified by [id].
  Future<void> delete(String id) => _local.delete(id);
}
