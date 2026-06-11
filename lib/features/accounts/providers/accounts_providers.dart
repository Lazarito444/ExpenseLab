import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/database/database_providers.dart';
import 'package:expenselab/features/accounts/data/datasources/accounts_local_datasource.dart';
import 'package:expenselab/features/accounts/data/datasources/accounts_local_datasource_impl.dart';
import 'package:expenselab/features/accounts/data/repositories/accounts_repository.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/exchange_rates/domain/models/exchange_rate_model.dart';
import 'package:expenselab/features/exchange_rates/providers/exchange_rates_providers.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
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
            if (tx.accountId == accountId) {
              balance -= tx.amount;
            } else {
              // Destination receives converted amount when rate is set.
              final received = tx.exchangeRate != null
                  ? tx.amount * tx.exchangeRate!
                  : tx.amount;
              balance += received;
            }
        }
      }
      return balance;
    },
    loading: () => 0.0,
    error: (e, s) => 0.0,
  );
});

/// Total net worth: sum of every account's balance converted to the app default currency.
/// Uses the in-memory exchange rates list for a synchronous lookup.
final totalNetWorthProvider = Provider<double>((ref) {
  final accounts = ref.watch(accountModelsProvider);
  final defaultCode = ref.watch(currencyProvider).code;
  final rates = ref.watch(exchangeRateModelsProvider);
  return accounts.fold(0.0, (sum, a) {
    return sum + _convertSync(a.balance, a.currencyCode, defaultCode, rates);
  });
});

/// Synchronously converts [amount] using the in-memory [rates] list.
/// Looks for the most recent rate on or before today for the pair, then falls
/// back to the latest available rate, then tries the inverse, then returns
/// [amount] unchanged if no rate is found.
double _convertSync(
  double amount,
  String from,
  String to,
  List<ExchangeRateModel> rates,
) {
  if (from == to) return amount;
  final today = DateTime.now();

  // Direct rates for the pair, sorted newest first.
  final direct = rates
      .where((r) => r.fromCurrencyCode == from && r.toCurrencyCode == to)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  if (direct.isNotEmpty) {
    final onOrBefore =
        direct.where((r) => !r.date.isAfter(today)).firstOrNull;
    final rate = (onOrBefore ?? direct.first).rate;
    return amount * rate;
  }

  // Inverse rates.
  final inverse = rates
      .where((r) => r.fromCurrencyCode == to && r.toCurrencyCode == from)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  if (inverse.isNotEmpty) {
    final onOrBefore =
        inverse.where((r) => !r.date.isAfter(today)).firstOrNull;
    final rate = (onOrBefore ?? inverse.first).rate;
    if (rate != 0) return amount / rate;
  }

  return amount;
}

/// Computes balance for every account from all transactions in one pass.
/// Watching a single provider avoids the variable-watch-count issue that
/// arises when calling ref.watch inside a loop over a dynamic list.
final _accountBalancesProvider = Provider<Map<String, double>>((ref) {
  final txs = ref.watch(transactionsProvider).maybeWhen(data: (v) => v, orElse: () => <Transaction>[]);
  final balances = <String, double>{};
  for (final tx in txs) {
    switch (tx.type) {
      case TransactionType.income:
        balances[tx.accountId] = (balances[tx.accountId] ?? 0) + tx.amount;
      case TransactionType.expense:
        balances[tx.accountId] = (balances[tx.accountId] ?? 0) - tx.amount;
      case TransactionType.transfer:
        balances[tx.accountId] = (balances[tx.accountId] ?? 0) - tx.amount;
        if (tx.toAccountId != null) {
          final received = tx.exchangeRate != null
              ? tx.amount * tx.exchangeRate!
              : tx.amount;
          balances[tx.toAccountId!] = (balances[tx.toAccountId!] ?? 0) + received;
        }
    }
  }
  return balances;
});

/// Maps every account to an [AccountModel] with its computed balance.
/// Returns an empty list while accounts are loading or on error.
final accountModelsProvider = Provider<List<AccountModel>>((ref) {
  final accounts = ref.watch(accountsProvider).maybeWhen(data: (v) => v, orElse: () => <Account>[]);
  final balances = ref.watch(_accountBalancesProvider);
  return accounts.map((a) => AccountModel.fromAccount(a, balances[a.id] ?? 0.0)).toList();
});
