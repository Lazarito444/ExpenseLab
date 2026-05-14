import 'package:expenselab/core/database/app_database.dart';

/// Contract for local storage access to [SavingsContribution] records.
///
/// Implementations must apply soft-delete semantics: [watchAll] and [getAll]
/// only surface rows where `isDeleted = false`, and [delete] flags rows as
/// deleted rather than removing them permanently.
///
/// Contributions are always scoped to a parent [SavingsGoal] via
/// `savingsGoalId`. Use [watchByGoalId] to observe the contribution history
/// for a specific goal.
abstract class SavingsContributionsLocalDataSource {
  /// Streams all non-deleted contributions, re-emitting the full list on every
  /// database change.
  Stream<List<SavingsContribution>> watchAll();

  /// Streams a single non-deleted contribution by [id], or `null` if not found
  /// or soft-deleted. Re-emits whenever the record is modified.
  Stream<SavingsContribution?> watchById(String id);

  /// Returns all non-deleted contributions as a one-shot future.
  Future<List<SavingsContribution>> getAll();

  /// Returns a single non-deleted contribution by [id], or `null` if not
  /// found.
  Future<SavingsContribution?> getById(String id);

  /// Streams all non-deleted contributions for the given [savingsGoalId].
  /// Re-emits on every change.
  Stream<List<SavingsContribution>> watchByGoalId(String savingsGoalId);

  /// Inserts a new contribution. [id], [createdAt], and [updatedAt] are
  /// assigned automatically — do not set them in [data]. Returns the generated
  /// [id].
  Future<String> create(SavingsContributionsCompanion data);

  /// Overwrites the mutable fields of the contribution with the given [id].
  /// [updatedAt] is stamped to the current time automatically.
  Future<void> update(String id, SavingsContributionsCompanion data);

  /// Soft-deletes the contribution: sets `isDeleted = true` and stamps
  /// `deletedAt` and `updatedAt` to the current time. The row is retained in
  /// the database.
  Future<void> delete(String id);
}
