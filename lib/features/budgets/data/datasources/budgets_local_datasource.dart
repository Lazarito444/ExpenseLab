import 'package:expenselab/core/database/app_database.dart';

/// Contract for local storage access to [Budget] records.
///
/// Implementations must apply soft-delete semantics: [watchAll] and [getAll]
/// only surface rows where `isDeleted = false`, and [delete] flags rows as
/// deleted rather than removing them permanently.
///
/// A budget is linked to a [Category] and optionally recurs via an RFC 5545
/// `rrule`. Open-ended budgets leave `endDate` as `null`.
abstract class BudgetsLocalDataSource {
  /// Streams all non-deleted budgets, re-emitting the full list on every
  /// database change.
  Stream<List<Budget>> watchAll();

  /// Streams a single non-deleted budget by [id], or `null` if not found or
  /// soft-deleted. Re-emits whenever the record is modified.
  Stream<Budget?> watchById(String id);

  /// Returns all non-deleted budgets as a one-shot future.
  Future<List<Budget>> getAll();

  /// Returns a single non-deleted budget by [id], or `null` if not found.
  Future<Budget?> getById(String id);

  /// Streams all non-deleted budgets associated with [categoryId]. Re-emits on
  /// every change.
  Stream<List<Budget>> watchByCategoryId(String categoryId);

  /// Inserts a new budget. [id], [createdAt], and [updatedAt] are assigned
  /// automatically — do not set them in [data]. Returns the generated [id].
  Future<String> create(BudgetsCompanion data);

  /// Overwrites the mutable fields of the budget with the given [id].
  /// [updatedAt] is stamped to the current time automatically.
  Future<void> update(String id, BudgetsCompanion data);

  /// Soft-deletes the budget: sets `isDeleted = true` and stamps `deletedAt`
  /// and `updatedAt` to the current time. The row is retained in the database.
  Future<void> delete(String id);
}
