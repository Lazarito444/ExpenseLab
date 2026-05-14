import 'package:expenselab/core/database/app_database.dart';

/// Contract for local storage access to [TransactionImage] records.
///
/// Unlike other datasources, this table has **no soft-delete column**. [delete]
/// and [deleteByTransactionId] permanently remove rows from the database.
/// Reads therefore return all existing rows without any `isDeleted` filter.
///
/// Call [deleteByTransactionId] before (or together with) soft-deleting the
/// parent [Transaction] to keep the database tidy.
abstract class TransactionImagesLocalDataSource {
  /// Streams all image records, re-emitting the full list on every database
  /// change.
  Stream<List<TransactionImage>> watchAll();

  /// Streams a single image record by [id], or `null` if not found. Re-emits
  /// whenever the record is modified.
  Stream<TransactionImage?> watchById(String id);

  /// Returns all image records as a one-shot future.
  Future<List<TransactionImage>> getAll();

  /// Returns a single image record by [id], or `null` if not found.
  Future<TransactionImage?> getById(String id);

  /// Streams all image records associated with [transactionId]. Re-emits on
  /// every change.
  Stream<List<TransactionImage>> watchByTransactionId(String transactionId);

  /// Inserts a new image record. [id], [createdAt], and [updatedAt] are
  /// assigned automatically — do not set them in [data]. Returns the generated
  /// [id].
  Future<String> create(TransactionImagesCompanion data);

  /// Overwrites the mutable fields of the image record with the given [id].
  /// [updatedAt] is stamped to the current time automatically.
  Future<void> update(String id, TransactionImagesCompanion data);

  /// Permanently removes the image record with the given [id] from the
  /// database. This operation is irreversible.
  Future<void> delete(String id);

  /// Permanently removes all image records associated with [transactionId].
  /// Useful for cascaded cleanup when a transaction is deleted.
  Future<void> deleteByTransactionId(String transactionId);
}
