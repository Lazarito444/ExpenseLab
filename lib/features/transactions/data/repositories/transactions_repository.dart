import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/transactions/data/datasources/transactions_local_datasource.dart';

/// Mediates access to [Transaction] data on behalf of application features.
///
/// Currently delegates all operations to [TransactionsLocalDataSource]. When a
/// remote data source is introduced, add it as a second field here and
/// implement an offline-first (or remote-first) strategy — callers and
/// providers are unaffected because they depend on this class, not on the
/// datasource directly.
class TransactionsRepository {
  const TransactionsRepository(this._local);

  final TransactionsLocalDataSource _local;

  /// Streams all non-deleted transactions, re-emitting on every database
  /// change.
  Stream<List<Transaction>> watchAll() => _local.watchAll();

  /// Streams a single non-deleted transaction by [id], or `null` if not found.
  Stream<Transaction?> watchById(String id) => _local.watchById(id);

  /// Returns all non-deleted transactions as a one-shot future.
  Future<List<Transaction>> getAll() => _local.getAll();

  /// Returns a single non-deleted transaction by [id], or `null` if not found.
  Future<Transaction?> getById(String id) => _local.getById(id);

  /// Streams all non-deleted transactions for [accountId] (source or
  /// destination).
  Stream<List<Transaction>> watchByAccountId(String accountId) => _local.watchByAccountId(accountId);

  /// Streams all non-deleted transactions within the inclusive date range
  /// [[from], [to]].
  Stream<List<Transaction>> watchByDateRange(DateTime from, DateTime to) => _local.watchByDateRange(from, to);

  /// Inserts a new transaction and returns its generated [id].
  Future<String> create(TransactionsCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the transaction identified by [id].
  Future<void> update(String id, TransactionsCompanion data) => _local.update(id, data);

  /// Soft-deletes the transaction identified by [id].
  Future<void> delete(String id) => _local.delete(id);
}
