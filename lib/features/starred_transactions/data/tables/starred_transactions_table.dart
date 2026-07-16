import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';

class StarredTransactions extends Table with TimestampedTable {
  IntColumn get type => intEnum<TransactionType>()();

  RealColumn get amount => real()();

  TextColumn get accountId => text()();

  TextColumn get toAccountId => text().nullable()();

  TextColumn get categoryId => text().nullable()();

  RealColumn get exchangeRate => real().nullable()();

  TextColumn get note => text().nullable()();
}
