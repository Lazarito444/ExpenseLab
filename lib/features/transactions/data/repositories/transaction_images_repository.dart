import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/transactions/data/datasources/transaction_images_local_datasource.dart';

/// Mediates access to [TransactionImage] data on behalf of application
/// features.
///
/// Images use hard-delete semantics (no `isDeleted` column), so [delete] and
/// [deleteByTransactionId] permanently remove rows.
///
/// Currently delegates all operations to [TransactionImagesLocalDataSource].
/// When a remote data source is introduced, add it as a second field here —
/// callers are unaffected.
class TransactionImagesRepository {
  const TransactionImagesRepository(this._local);

  final TransactionImagesLocalDataSource _local;

  /// Streams all image records, re-emitting on every database change.
  Stream<List<TransactionImage>> watchAll() => _local.watchAll();

  /// Streams a single image record by [id], or `null` if not found.
  Stream<TransactionImage?> watchById(String id) => _local.watchById(id);

  /// Returns all image records as a one-shot future.
  Future<List<TransactionImage>> getAll() => _local.getAll();

  /// Returns a single image record by [id], or `null` if not found.
  Future<TransactionImage?> getById(String id) => _local.getById(id);

  /// Streams all image records for [transactionId], re-emitting on every
  /// change.
  Stream<List<TransactionImage>> watchByTransactionId(String transactionId) =>
      _local.watchByTransactionId(transactionId);

  /// Inserts a new image record and returns its generated [id].
  Future<String> create(TransactionImagesCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the image record identified by [id].
  Future<void> update(String id, TransactionImagesCompanion data) =>
      _local.update(id, data);

  /// Permanently deletes the image record identified by [id].
  Future<void> delete(String id) => _local.delete(id);

  /// Permanently deletes all image records associated with [transactionId].
  Future<void> deleteByTransactionId(String transactionId) =>
      _local.deleteByTransactionId(transactionId);
}
