import 'package:expenselab/core/database/app_database.dart';

/// Contract for local storage access to [SavingsGoal] records.
///
/// Implementations must apply soft-delete semantics: [watchAll] and [getAll]
/// only surface rows where `isDeleted = false`, and [delete] flags rows as
/// deleted rather than removing them permanently.
///
/// A savings goal tracks a target amount and an optional deadline. Monetary
/// progress is recorded separately through [SavingsContribution] records
/// linked by `savingsGoalId`.
abstract class SavingsGoalsLocalDataSource {
  /// Streams all non-deleted savings goals, re-emitting the full list on every
  /// database change.
  Stream<List<SavingsGoal>> watchAll();

  /// Streams a single non-deleted savings goal by [id], or `null` if not found
  /// or soft-deleted. Re-emits whenever the record is modified.
  Stream<SavingsGoal?> watchById(String id);

  /// Returns all non-deleted savings goals as a one-shot future.
  Future<List<SavingsGoal>> getAll();

  /// Returns a single non-deleted savings goal by [id], or `null` if not
  /// found.
  Future<SavingsGoal?> getById(String id);

  /// Inserts a new savings goal. [id], [createdAt], and [updatedAt] are
  /// assigned automatically — do not set them in [data]. Returns the generated
  /// [id].
  Future<String> create(SavingsGoalsCompanion data);

  /// Overwrites the mutable fields of the savings goal with the given [id].
  /// [updatedAt] is stamped to the current time automatically.
  Future<void> update(String id, SavingsGoalsCompanion data);

  /// Soft-deletes the savings goal: sets `isDeleted = true` and stamps
  /// `deletedAt` and `updatedAt` to the current time. The row is retained in
  /// the database.
  Future<void> delete(String id);
}
