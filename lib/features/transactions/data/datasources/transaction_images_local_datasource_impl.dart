import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/transactions/data/datasources/transaction_images_local_datasource.dart';

/// Drift-backed implementation of [TransactionImagesLocalDataSource].
///
/// This table uses [TimestampedTable] (no `isDeleted` column), so all rows are
/// returned by read methods without any soft-delete filter. Deletions are
/// permanent.
///
/// [create] only assigns [id]; [createdAt] and [updatedAt] are handled by the
/// [TimestampedTable] client defaults.
class TransactionImagesLocalDataSourceImpl implements TransactionImagesLocalDataSource {
  const TransactionImagesLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<TransactionImage>> watchAll() => _db.select(_db.transactionImages).watch();

  @override
  Stream<TransactionImage?> watchById(String id) => (_db.select(_db.transactionImages)..where((t) => t.id.equals(id))).watchSingleOrNull();

  @override
  Future<List<TransactionImage>> getAll() => _db.select(_db.transactionImages).get();

  @override
  Future<TransactionImage?> getById(String id) => (_db.select(_db.transactionImages)..where((t) => t.id.equals(id))).getSingleOrNull();

  @override
  Stream<List<TransactionImage>> watchByTransactionId(String transactionId) => (_db.select(_db.transactionImages)..where((t) => t.transactionId.equals(transactionId))).watch();

  @override
  Future<String> create(TransactionImagesCompanion data) async {
    final id = newId();
    await _db.into(_db.transactionImages).insert(data.copyWith(id: Value(id)));
    return id;
  }

  @override
  Future<void> update(String id, TransactionImagesCompanion data) => (_db.update(_db.transactionImages)..where((t) => t.id.equals(id))).write(data.copyWith(updatedAt: Value(DateTime.now().toUtc())));

  @override
  Future<void> delete(String id) => (_db.delete(_db.transactionImages)..where((t) => t.id.equals(id))).go();

  @override
  Future<List<TransactionImage>> getByTransactionId(String transactionId) =>
      (_db.select(_db.transactionImages)..where((t) => t.transactionId.equals(transactionId))).get();

  @override
  Future<void> deleteByTransactionId(String transactionId) => (_db.delete(_db.transactionImages)..where((t) => t.transactionId.equals(transactionId))).go();
}
