import 'package:expense_lab/data/datasources/local/isar_repository.dart';
import 'package:expense_lab/data/models/account/account_model.dart';
import 'package:expense_lab/domain/entities/account.dart';
import 'package:expense_lab/domain/repositories/i_account_repository.dart';
import 'package:isar/isar.dart';

class AccountRepositoryImpl extends IsarRepository<Account, AccountModel> implements IAccountRepository {
  AccountRepositoryImpl(Isar isar) : super(isar, isar.accountModels);

  @override
  Account mapToEntity(AccountModel model) {
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

  @override
  AccountModel mapToModel(Account entity) {
    return AccountModel()
      ..id = entity.id ?? Isar.autoIncrement
      ..name = entity.name
      ..currencyCode = entity.currencyCode
      ..currentBalance = entity.currentBalance
      ..colorHex = entity.colorHex
      ..iconCodePoint = entity.iconCodePoint
      ..isArchived = entity.isArchived;
  }

  @override
  int getModelId(AccountModel model) => model.id;
}
