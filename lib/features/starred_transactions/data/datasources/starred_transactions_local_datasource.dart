import 'package:expenselab/core/database/app_database.dart';

abstract class StarredTransactionsLocalDataSource {
  Stream<List<StarredTransaction>> watchAll();

  Stream<StarredTransaction?> watchById(String id);

  Future<List<StarredTransaction>> getAll();

  Future<StarredTransaction?> getById(String id);

  Future<String> create(StarredTransactionsCompanion data);

  Future<void> update(String id, StarredTransactionsCompanion data);

  Future<void> delete(String id);
}
