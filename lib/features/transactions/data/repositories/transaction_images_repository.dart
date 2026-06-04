import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/transactions/data/datasources/transaction_images_local_datasource.dart';
import 'package:expenselab/features/transactions/domain/models/transaction_image_model.dart';

/// Mediates access to [TransactionImageModel] data on behalf of application
/// features.
///
/// Converts Drift-generated [TransactionImage] entities to
/// [TransactionImageModel] at the repository boundary so callers never depend
/// on the persistence layer directly. Write operations still accept
/// [TransactionImagesCompanion] — the database type — because callers build
/// companions themselves.
///
/// Images use hard-delete semantics (no `isDeleted` column), so [delete] and
/// [deleteByTransactionId] permanently remove rows.
///
/// When a remote data source is introduced, add it as a second field here —
/// callers are unaffected.
class TransactionImagesRepository {
  const TransactionImagesRepository(this._local);

  final TransactionImagesLocalDataSource _local;

  /// Streams all image records as [TransactionImageModel], re-emitting on
  /// every database change.
  Stream<List<TransactionImageModel>> watchAll() =>
      _local.watchAll().map(
        (list) => list.map(TransactionImageModel.fromTransactionImage).toList(),
      );

  /// Streams a single image record by [id] as [TransactionImageModel], or
  /// `null` if not found.
  Stream<TransactionImageModel?> watchById(String id) =>
      _local.watchById(id).map(
        (img) => img != null ? TransactionImageModel.fromTransactionImage(img) : null,
      );

  /// Returns all image records as a one-shot future.
  Future<List<TransactionImageModel>> getAll() async =>
      (await _local.getAll()).map(TransactionImageModel.fromTransactionImage).toList();

  /// Returns a single image record by [id], or `null` if not found.
  Future<TransactionImageModel?> getById(String id) async {
    final img = await _local.getById(id);
    return img != null ? TransactionImageModel.fromTransactionImage(img) : null;
  }

  /// Streams all image records for [transactionId] as [TransactionImageModel],
  /// re-emitting on every change.
  Stream<List<TransactionImageModel>> watchByTransactionId(String transactionId) =>
      _local.watchByTransactionId(transactionId).map(
        (list) => list.map(TransactionImageModel.fromTransactionImage).toList(),
      );

  /// Inserts a new image record and returns its generated [id].
  Future<String> create(TransactionImagesCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the image record identified by [id].
  Future<void> update(String id, TransactionImagesCompanion data) => _local.update(id, data);

  /// Permanently deletes the image record identified by [id].
  Future<void> delete(String id) => _local.delete(id);

  /// Permanently deletes all image records associated with [transactionId].
  Future<void> deleteByTransactionId(String transactionId) =>
      _local.deleteByTransactionId(transactionId);
}
