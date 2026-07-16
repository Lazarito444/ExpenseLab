import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/starred_transactions/data/datasources/starred_transactions_local_datasource.dart';

class StarredTransactionsLocalDataSourceImpl implements StarredTransactionsLocalDataSource {
  const StarredTransactionsLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<StarredTransaction>> watchAll() => _db.select(_db.starredTransactions).watch();

  @override
  Stream<StarredTransaction?> watchById(String id) => (_db.select(_db.starredTransactions)..where((t) => t.id.equals(id))).watchSingleOrNull();

  @override
  Future<List<StarredTransaction>> getAll() => _db.select(_db.starredTransactions).get();

  @override
  Future<StarredTransaction?> getById(String id) => (_db.select(_db.starredTransactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  @override
  Future<String> create(StarredTransactionsCompanion data) async {
    final id = newId();
    await _db.into(_db.starredTransactions).insert(data.copyWith(id: Value(id)));
    return id;
  }

  @override
  Future<void> update(String id, StarredTransactionsCompanion data) => (_db.update(_db.starredTransactions)..where((t) => t.id.equals(id))).write(data.copyWith(updatedAt: Value(DateTime.now().toUtc())));

  @override
  Future<void> delete(String id) => (_db.delete(_db.starredTransactions)..where((t) => t.id.equals(id))).go();
}
