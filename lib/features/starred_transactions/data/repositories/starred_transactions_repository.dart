import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/starred_transactions/data/datasources/starred_transactions_local_datasource.dart';

class StarredTransactionsRepository {
  const StarredTransactionsRepository(this._local);

  final StarredTransactionsLocalDataSource _local;

  Stream<List<StarredTransaction>> watchAll() => _local.watchAll();

  Stream<StarredTransaction?> watchById(String id) => _local.watchById(id);

  Future<List<StarredTransaction>> getAll() => _local.getAll();

  Future<StarredTransaction?> getById(String id) => _local.getById(id);

  Future<String> create(StarredTransactionsCompanion data) => _local.create(data);

  Future<void> update(String id, StarredTransactionsCompanion data) => _local.update(id, data);

  Future<void> delete(String id) => _local.delete(id);
}
