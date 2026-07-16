import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/database/database_providers.dart';
import 'package:expenselab/features/starred_transactions/data/datasources/starred_transactions_local_datasource.dart';
import 'package:expenselab/features/starred_transactions/data/datasources/starred_transactions_local_datasource_impl.dart';
import 'package:expenselab/features/starred_transactions/data/repositories/starred_transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final starredTransactionsLocalDataSourceProvider = Provider<StarredTransactionsLocalDataSource>((ref) {
  return StarredTransactionsLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final starredTransactionsRepositoryProvider = Provider<StarredTransactionsRepository>((ref) {
  return StarredTransactionsRepository(ref.watch(starredTransactionsLocalDataSourceProvider));
});

final starredTransactionsStreamProvider = StreamProvider<List<StarredTransaction>>((ref) {
  return ref.watch(starredTransactionsRepositoryProvider).watchAll();
});

final starredTransactionsListProvider = FutureProvider<List<StarredTransaction>>((ref) {
  return ref.watch(starredTransactionsRepositoryProvider).getAll();
});
