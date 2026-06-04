import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/savings/data/datasources/savings_contributions_local_datasource.dart';
import 'package:expenselab/features/savings/domain/models/savings_contribution_model.dart';

/// Mediates access to [SavingsContributionModel] data on behalf of application
/// features.
///
/// Converts Drift-generated [SavingsContribution] entities to
/// [SavingsContributionModel] at the repository boundary so callers never
/// depend on the persistence layer directly. Write operations still accept
/// [SavingsContributionsCompanion] — the database type — because form screens
/// build companions themselves.
///
/// When a remote data source is introduced, add it as a second field here and
/// implement an offline-first (or remote-first) strategy — callers and
/// providers are unaffected because they depend on this class, not on the
/// datasource directly.
class SavingsContributionsRepository {
  const SavingsContributionsRepository(this._local);

  final SavingsContributionsLocalDataSource _local;

  /// Streams all non-deleted contributions as [SavingsContributionModel],
  /// re-emitting on every database change.
  Stream<List<SavingsContributionModel>> watchAll() =>
      _local.watchAll().map(
        (list) => list.map(SavingsContributionModel.fromSavingsContribution).toList(),
      );

  /// Streams a single non-deleted contribution by [id] as
  /// [SavingsContributionModel], or `null` if not found.
  Stream<SavingsContributionModel?> watchById(String id) =>
      _local.watchById(id).map(
        (c) => c != null ? SavingsContributionModel.fromSavingsContribution(c) : null,
      );

  /// Returns all non-deleted contributions as a one-shot future.
  Future<List<SavingsContributionModel>> getAll() async =>
      (await _local.getAll()).map(SavingsContributionModel.fromSavingsContribution).toList();

  /// Returns a single non-deleted contribution by [id], or `null` if not
  /// found.
  Future<SavingsContributionModel?> getById(String id) async {
    final c = await _local.getById(id);
    return c != null ? SavingsContributionModel.fromSavingsContribution(c) : null;
  }

  /// Streams all non-deleted contributions for [savingsGoalId] as
  /// [SavingsContributionModel], re-emitting on every change.
  Stream<List<SavingsContributionModel>> watchByGoalId(String savingsGoalId) =>
      _local.watchByGoalId(savingsGoalId).map(
        (list) => list.map(SavingsContributionModel.fromSavingsContribution).toList(),
      );

  /// Inserts a new contribution and returns its generated [id].
  Future<String> create(SavingsContributionsCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the contribution identified by [id].
  Future<void> update(String id, SavingsContributionsCompanion data) => _local.update(id, data);

  /// Soft-deletes the contribution identified by [id].
  Future<void> delete(String id) => _local.delete(id);
}
