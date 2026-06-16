import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';

enum TransactionType { income, expense, transfer }

class Transactions extends Table with SoftDeleteTable {
  /// Type of the transaction.
  IntColumn get type => intEnum<TransactionType>()();

  /// Amount of the transaction.
  RealColumn get amount => real()();

  /// Date and time of the transaction.
  DateTimeColumn get date => dateTime()();

  /// Note of the transaction.
  TextColumn get note => text().nullable()();

  /// RRULE per RFC 5545; null for one-off transactions.
  TextColumn get rrule => text().nullable()();

  /// ID of the account the transaction is from.
  @ReferenceName('transactions')
  TextColumn get accountId => text().references(Accounts, #id)();

  /// ID of the account the transaction is to (only for transfers).
  @ReferenceName('transferTransactions')
  TextColumn get toAccountId => text().nullable().references(Accounts, #id)();

  /// ID of the category the transaction is (only for income and expenses).
  TextColumn get categoryId => text().nullable().references(Categories, #id)();

  /// Exchange rate from [accountId] currency to [toAccountId] currency.
  /// Only set on cross-currency transfers; null otherwise.
  RealColumn get exchangeRate => real().nullable()();

  /// ID of the template transaction this occurrence was generated from.
  /// Null for regular transactions and recurrence templates themselves.
  TextColumn get recurrenceId => text().nullable().named('recurrence_id')();
}
