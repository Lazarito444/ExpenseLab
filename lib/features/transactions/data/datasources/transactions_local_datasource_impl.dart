import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/transactions/data/datasources/transactions_local_datasource.dart';

/// Drift-backed implementation of [TransactionsLocalDataSource].
///
/// All read methods exclude soft-deleted rows (`isDeleted = true`).
/// [create] only assigns [id]; [createdAt], [updatedAt], and [isDeleted] are
/// handled by the [SoftDeleteTable] client defaults.
///
/// [watchByAccountId] matches both `accountId` and `toAccountId` so that
/// transfer transactions appear in the stream for either the source or
/// destination account.
class TransactionsLocalDataSourceImpl implements TransactionsLocalDataSource {
  const TransactionsLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Transaction>> watchAll() => (_db.select(_db.transactions)..where((t) => t.isDeleted.equals(false))).watch();

  @override
  Stream<Transaction?> watchById(String id) => (_db.select(_db.transactions)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).watchSingleOrNull();

  @override
  Future<List<Transaction>> getAll() => (_db.select(_db.transactions)..where((t) => t.isDeleted.equals(false))).get();

  @override
  Future<Transaction?> getById(String id) => (_db.select(_db.transactions)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).getSingleOrNull();

  @override
  Stream<List<Transaction>> watchByAccountId(String accountId) =>
      (_db.select(_db.transactions)..where((t) => t.isDeleted.equals(false) & (t.accountId.equals(accountId) | t.toAccountId.equals(accountId)))).watch();

  @override
  Stream<List<Transaction>> watchByDateRange(DateTime from, DateTime to) =>
      (_db.select(_db.transactions)..where((t) => t.isDeleted.equals(false) & t.date.isBiggerOrEqualValue(from) & t.date.isSmallerOrEqualValue(to))).watch();

  @override
  Future<String> create(TransactionsCompanion data) async {
    final id = newId();
    await _db.into(_db.transactions).insert(data.copyWith(id: Value(id)));
    return id;
  }

  @override
  Future<void> update(String id, TransactionsCompanion data) => (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(data.copyWith(updatedAt: Value(DateTime.now().toUtc())));

  @override
  Future<void> delete(String id) {
    final now = DateTime.now().toUtc();
    return (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
