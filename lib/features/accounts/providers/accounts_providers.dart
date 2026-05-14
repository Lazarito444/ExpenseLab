import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/providers/database_providers.dart';
import 'package:expenselab/features/accounts/data/datasources/accounts_local_datasource.dart';
import 'package:expenselab/features/accounts/data/datasources/accounts_local_datasource_impl.dart';
import 'package:expenselab/features/accounts/data/repositories/accounts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides [AccountsLocalDataSourceImpl] bound to the [AccountsLocalDataSource]
/// interface. Swap the implementation here to change the storage backend
/// without touching any repository or UI code.
final accountsLocalDataSourceProvider = Provider<AccountsLocalDataSource>((ref) {
  return AccountsLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

/// Provides the singleton [AccountsRepository], wired to
/// [accountsLocalDataSourceProvider].
final accountsRepositoryProvider = Provider<AccountsRepository>((ref) {
  return AccountsRepository(ref.watch(accountsLocalDataSourceProvider));
});

/// Streams all non-deleted [Account] records. Automatically re-emits whenever
/// the underlying table changes.
///
/// Usage: `ref.watch(accountsProvider)` returns `AsyncValue<List<Account>>`.
final accountsProvider = StreamProvider<List<Account>>((ref) {
  return ref.watch(accountsRepositoryProvider).watchAll();
});

/// Streams a single [Account] by [id], or `null` if not found or soft-deleted.
/// Re-emits whenever the record changes.
///
/// Usage: `ref.watch(accountByIdProvider('some-id'))` returns
/// `AsyncValue<Account?>`.
final accountByIdProvider = StreamProvider.family<Account?, String>((ref, id) {
  return ref.watch(accountsRepositoryProvider).watchById(id);
});
