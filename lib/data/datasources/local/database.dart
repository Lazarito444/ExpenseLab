import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:expense_lab/data/datasources/local/tables/accounts_table.dart';
import 'package:expense_lab/data/datasources/local/tables/financial_events_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Accounts, FinancialEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'expense_lab');
}
