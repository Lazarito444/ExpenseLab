import 'package:expenselab/core/database/app_database.dart';

/// Contract for local storage access to [Account] records.
///
/// Implementations must apply soft-delete semantics: [watchAll] and [getAll]
/// only surface rows where `isDeleted = false`, and [delete] flags rows as
/// deleted rather than removing them permanently from the database.
///
/// To add a remote data source in the future, create a parallel interface
/// (e.g. `AccountsRemoteDataSource`) and let [AccountsRepository] orchestrate
/// both without touching this contract.
abstract class AccountsLocalDataSource {
  /// Streams all non-deleted accounts, re-emitting the full list on every
  /// database change.
  Stream<List<Account>> watchAll();

  /// Streams a single non-deleted account by [id], or `null` if not found or
  /// soft-deleted. Re-emits whenever the record is modified.
  Stream<Account?> watchById(String id);

  /// Returns all non-deleted accounts as a one-shot future.
  Future<List<Account>> getAll();

  /// Returns a single non-deleted account by [id], or `null` if not found.
  Future<Account?> getById(String id);

  /// Inserts a new account. [id], [createdAt], and [updatedAt] are assigned
  /// automatically — do not set them in [data]. Returns the generated [id].
  Future<String> create(AccountsCompanion data);

  /// Overwrites the mutable fields of the account with the given [id].
  /// [updatedAt] is stamped to the current time automatically.
  Future<void> update(String id, AccountsCompanion data);

  /// Soft-deletes the account: sets `isDeleted = true` and stamps `deletedAt`
  /// and `updatedAt` to the current time. The row is retained in the database.
  Future<void> delete(String id);

  /// Reorders the account from [oldIndex] to [newIndex] within its type group.
  /// All accounts of the same [AccountType] are re-indexed atomically so their
  /// [sortOrder] values remain contiguous.
  Future<void> reorderAccount(String id, int oldIndex, int newIndex);
}
