import 'package:expenselab/core/database/app_database.dart';

/// Contract for local storage access to [Transaction] records.
///
/// Implementations must apply soft-delete semantics: [watchAll] and [getAll]
/// only surface rows where `isDeleted = false`, and [delete] flags rows as
/// deleted rather than removing them permanently.
///
/// Transfers are modelled as a single [Transaction] row with both [accountId]
/// (source) and [toAccountId] (destination) populated. [watchByAccountId]
/// matches both sides, so transfers appear in the stream for either account.
abstract class TransactionsLocalDataSource {
  /// Streams all non-deleted transactions, re-emitting the full list on every
  /// database change.
  Stream<List<Transaction>> watchAll();

  /// Streams a single non-deleted transaction by [id], or `null` if not found
  /// or soft-deleted. Re-emits whenever the record is modified.
  Stream<Transaction?> watchById(String id);

  /// Returns all non-deleted transactions as a one-shot future.
  Future<List<Transaction>> getAll();

  /// Returns a single non-deleted transaction by [id], or `null` if not found.
  Future<Transaction?> getById(String id);

  /// Streams all non-deleted transactions whose source *or* destination account
  /// matches [accountId]. Re-emits on every change.
  Stream<List<Transaction>> watchByAccountId(String accountId);

  /// Streams all non-deleted transactions whose date falls within the inclusive
  /// range [[from], [to]]. Re-emits on every change.
  Stream<List<Transaction>> watchByDateRange(DateTime from, DateTime to);

  /// Inserts a new transaction. [id], [createdAt], and [updatedAt] are assigned
  /// automatically — do not set them in [data]. Returns the generated [id].
  Future<String> create(TransactionsCompanion data);

  /// Overwrites the mutable fields of the transaction with the given [id].
  /// [updatedAt] is stamped to the current time automatically.
  Future<void> update(String id, TransactionsCompanion data);

  /// Soft-deletes the transaction: sets `isDeleted = true` and stamps
  /// `deletedAt` and `updatedAt` to the current time.
  Future<void> delete(String id);
}
