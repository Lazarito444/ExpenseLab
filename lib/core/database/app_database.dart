import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';
import 'package:expenselab/features/budgets/data/tables/budgets_table.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:expenselab/features/savings/data/tables/savings_contributions_table.dart';
import 'package:expenselab/features/savings/data/tables/savings_goals_table.dart';
import 'package:expenselab/features/transactions/data/tables/transaction_images_table.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// The main database class that holds all the tables.
@DriftDatabase(
  tables: [
    Accounts,
    Categories,
    Transactions,
    TransactionImages,
    Budgets,
    SavingsGoals,
    SavingsContributions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Future migrations go here.
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'expenselab.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
