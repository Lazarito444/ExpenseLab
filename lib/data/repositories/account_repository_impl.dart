import 'package:drift/drift.dart';
import 'package:expense_lab/data/datasources/local/database.dart';
import 'package:expense_lab/domain/entities/account.dart';
import 'package:expense_lab/domain/repositories/i_account_repository.dart';

class AccountRepositoryImpl implements IAccountRepository {
  final AppDatabase _db;

  AccountRepositoryImpl(this._db);

  Account _mapToEntity(AccountDbModel model) {
    return Account(
      id: model.id,
      name: model.name,
      currencyCode: model.currencyCode,
      currentBalance: model.currentBalance,
      colorHex: model.colorHex,
      iconCodePoint: model.iconCodePoint,
      isArchived: model.isArchived,
    );
  }

  AccountsCompanion _mapToCompanion(Account entity) {
    return AccountsCompanion(
      id: entity.id != null ? Value(entity.id!) : const Value.absent(),
      name: Value(entity.name),
      currencyCode: Value(entity.currencyCode),
      currentBalance: Value(entity.currentBalance),
      colorHex: Value(entity.colorHex),
      iconCodePoint: Value(entity.iconCodePoint),
      isArchived: Value(entity.isArchived),
    );
  }

  @override
  Future<List<Account>> getAll() async {
    final models = await _db.select(_db.accounts).get();
    return models.map(_mapToEntity).toList();
  }

  @override
  Future<Account?> getById(int id) async {
    final model = await (_db.select(_db.accounts)..where((t) => t.id.equals(id))).getSingleOrNull();
    return model != null ? _mapToEntity(model) : null;
  }

  @override
  Future<int> upsert(Account entity) async {
    final companion = _mapToCompanion(entity);
    return await _db.into(_db.accounts).insertOnConflictUpdate(companion);
  }

  @override
  Future<bool> delete(int id) async {
    final rowsAffected = await (_db.delete(_db.accounts)..where((t) => t.id.equals(id))).go();
    return rowsAffected > 0;
  }
}
