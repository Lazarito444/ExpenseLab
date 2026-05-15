import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/database/database_providers.dart';
import 'package:expenselab/features/transactions/data/datasources/transaction_images_local_datasource.dart';
import 'package:expenselab/features/transactions/data/datasources/transaction_images_local_datasource_impl.dart';
import 'package:expenselab/features/transactions/data/datasources/transactions_local_datasource.dart';
import 'package:expenselab/features/transactions/data/datasources/transactions_local_datasource_impl.dart';
import 'package:expenselab/features/transactions/data/repositories/transaction_images_repository.dart';
import 'package:expenselab/features/transactions/data/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Transactions ──────────────────────────────────────────────────────────────

/// Provides [TransactionsLocalDataSourceImpl] bound to the
/// [TransactionsLocalDataSource] interface. Swap the implementation here to
/// change the storage backend without touching any repository or UI code.
final transactionsLocalDataSourceProvider = Provider<TransactionsLocalDataSource>((ref) {
  return TransactionsLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

/// Provides the singleton [TransactionsRepository], wired to
/// [transactionsLocalDataSourceProvider].
final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepository(ref.watch(transactionsLocalDataSourceProvider));
});

/// Streams all non-deleted [Transaction] records. Automatically re-emits
/// whenever the underlying table changes.
///
/// Usage: `ref.watch(transactionsProvider)` returns
/// `AsyncValue<List<Transaction>>`.
final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  return ref.watch(transactionsRepositoryProvider).watchAll();
});

/// Streams a single [Transaction] by [id], or `null` if not found or
/// soft-deleted. Re-emits whenever the record changes.
final transactionByIdProvider = StreamProvider.family<Transaction?, String>((ref, id) {
  return ref.watch(transactionsRepositoryProvider).watchById(id);
});

/// Streams all non-deleted transactions whose source *or* destination account
/// matches [accountId]. Re-emits on every change.
///
/// Usage: `ref.watch(transactionsByAccountProvider('account-id'))`.
final transactionsByAccountProvider = StreamProvider.family<List<Transaction>, String>((ref, accountId) {
  return ref.watch(transactionsRepositoryProvider).watchByAccountId(accountId);
});

// ── TransactionImages ─────────────────────────────────────────────────────────

/// Provides [TransactionImagesLocalDataSourceImpl] bound to the
/// [TransactionImagesLocalDataSource] interface.
final transactionImagesLocalDataSourceProvider = Provider<TransactionImagesLocalDataSource>((ref) {
  return TransactionImagesLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

/// Provides the singleton [TransactionImagesRepository], wired to
/// [transactionImagesLocalDataSourceProvider].
final transactionImagesRepositoryProvider = Provider<TransactionImagesRepository>((ref) {
  return TransactionImagesRepository(ref.watch(transactionImagesLocalDataSourceProvider));
});

/// Streams all [TransactionImage] records associated with [transactionId].
/// Re-emits on every change.
///
/// Usage: `ref.watch(transactionImagesByTransactionProvider('tx-id'))`.
final transactionImagesByTransactionProvider = StreamProvider.family<List<TransactionImage>, String>((ref, transactionId) {
  return ref.watch(transactionImagesRepositoryProvider).watchByTransactionId(transactionId);
});
