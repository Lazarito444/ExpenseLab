import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/accounts/data/datasources/accounts_local_datasource.dart';

/// Mediates access to [Account] data on behalf of application features.
///
/// Currently delegates all operations to [AccountsLocalDataSource]. When a
/// remote data source is introduced, add it as a second field here and
/// implement an offline-first (or remote-first) strategy — callers and
/// providers are unaffected because they depend on this class, not on the
/// datasource directly.
class AccountsRepository {
  const AccountsRepository(this._local);

  final AccountsLocalDataSource _local;

  /// Streams all non-deleted accounts, re-emitting on every database change.
  Stream<List<Account>> watchAll() => _local.watchAll();

  /// Streams a single non-deleted account by [id], or `null` if not found.
  Stream<Account?> watchById(String id) => _local.watchById(id);

  /// Returns all non-deleted accounts as a one-shot future.
  Future<List<Account>> getAll() => _local.getAll();

  /// Returns a single non-deleted account by [id], or `null` if not found.
  Future<Account?> getById(String id) => _local.getById(id);

  /// Inserts a new account and returns its generated [id].
  Future<String> create(AccountsCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the account identified by [id].
  Future<void> update(String id, AccountsCompanion data) => _local.update(id, data);

  /// Soft-deletes the account identified by [id].
  Future<void> delete(String id) => _local.delete(id);
}
