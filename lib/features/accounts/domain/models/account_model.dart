import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';

class AccountModel {
  const AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.currencyCode,
    required this.icon,
    required this.balance,
  });

  final String id;
  final String name;
  final AccountType type;
  final String currencyCode;
  final String icon;
  final double balance;

  factory AccountModel.fromAccount(Account account, double balance) =>
      AccountModel(
        id: account.id,
        name: account.name,
        type: account.type,
        currencyCode: account.currencyCode,
        icon: account.icon,
        balance: balance,
      );
}
