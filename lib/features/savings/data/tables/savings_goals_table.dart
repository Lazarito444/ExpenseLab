import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';

class SavingsGoals extends Table with SoftDeleteTable {
  /// Name of the savings goal.
  TextColumn get name => text()();

  /// Target amount of the savings goal.
  RealColumn get targetAmount => real()();

  /// Source account ID of the savings goal.
  TextColumn get sourceAccountId => text().references(Accounts, #id)();

  /// Target date of the savings goal, null means it has no deadline.
  DateTimeColumn get targetDate => dateTime().nullable()();
}
