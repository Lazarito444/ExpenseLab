import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/database/database_providers.dart';
import 'package:expenselab/features/accounts/data/datasources/accounts_local_datasource.dart';
import 'package:expenselab/features/accounts/data/datasources/accounts_local_datasource_impl.dart';
import 'package:expenselab/features/accounts/data/repositories/accounts_repository.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
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

/// Computes the running balance for a single account by summing its transactions.
///
/// - income credited to [accountId]: `+ amount`
/// - expense debited from [accountId]: `- amount`
/// - transfer from [accountId]: `- amount`; transfer to [accountId]: `+ amount`
///
/// Returns `0.0` while loading or on error so the UI stays non-null.
final accountBalanceProvider = Provider.family<double, String>((ref, accountId) {
  final txsAsync = ref.watch(transactionsByAccountProvider(accountId));
  return txsAsync.when(
    data: (txs) {
      var balance = 0.0;
      for (final tx in txs) {
        switch (tx.type) {
          case TransactionType.income:
            balance += tx.amount;
          case TransactionType.expense:
            balance -= tx.amount;
          case TransactionType.transfer:
            balance += tx.accountId == accountId ? -tx.amount : tx.amount;
        }
      }
      return balance;
    },
    loading: () => 0.0,
    error: (e, s) => 0.0,
  );
});

/// Total net worth: algebraic sum of every account's balance.
final totalNetWorthProvider = Provider<double>((ref) {
  final accounts = switch (ref.watch(accountsProvider)) {
    AsyncData(:final value) => value,
    _ => <Account>[],
  };
  return accounts.fold(0.0, (sum, a) => sum + ref.watch(accountBalanceProvider(a.id)));
});

/// Maps every account to an [AccountModel] with its computed balance.
/// Returns an empty list while accounts are loading or on error.
final accountModelsProvider = Provider<List<AccountModel>>((ref) {
  final accounts = ref.watch(accountsProvider).maybeWhen(
    data: (list) => list,
    orElse: () => <Account>[],
  );
  return accounts.map((account) {
    final balance = ref.watch(accountBalanceProvider(account.id));
    return AccountModel.fromAccount(account, balance);
  }).toList();
});
