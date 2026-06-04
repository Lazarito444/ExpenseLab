import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/accounts/data/datasources/accounts_local_datasource.dart';

/// Drift-backed implementation of [AccountsLocalDataSource].
///
/// All read methods exclude soft-deleted rows (`isDeleted = true`).
/// [create] only assigns [id]; [createdAt], [updatedAt], and [isDeleted] are
/// handled by the [SoftDeleteTable] client defaults.
class AccountsLocalDataSourceImpl implements AccountsLocalDataSource {
  const AccountsLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Account>> watchAll() => (_db.select(_db.accounts)..where((t) => t.isDeleted.equals(false))).watch();

  @override
  Stream<Account?> watchById(String id) => (_db.select(_db.accounts)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).watchSingleOrNull();

  @override
  Future<List<Account>> getAll() => (_db.select(_db.accounts)..where((t) => t.isDeleted.equals(false))).get();

  @override
  Future<Account?> getById(String id) => (_db.select(_db.accounts)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).getSingleOrNull();

  @override
  Future<String> create(AccountsCompanion data) async {
    final id = newId();
    await _db.into(_db.accounts).insert(data.copyWith(id: Value(id)));
    return id;
  }

  @override
  Future<void> update(String id, AccountsCompanion data) => (_db.update(_db.accounts)..where((t) => t.id.equals(id))).write(data.copyWith(updatedAt: Value(DateTime.now().toUtc())));

  @override
  Future<void> delete(String id) => _db.transaction(() async {
    final now = DateTime.now().toUtc();

    // Cascade: soft-delete all savings goals linked to this account.
    await (_db.update(_db.savingsGoals)..where((t) => t.sourceAccountId.equals(id))).write(
      SavingsGoalsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    // Soft-delete the account itself.
    await (_db.update(_db.accounts)..where((t) => t.id.equals(id))).write(
      AccountsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  });
}
