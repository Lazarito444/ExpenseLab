import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';
import 'package:expenselab/features/savings/data/tables/savings_goals_table.dart';

class SavingsContributions extends Table with SoftDeleteTable {
  /// ID of the savings goal.
  TextColumn get savingsGoalId => text().references(SavingsGoals, #id)();

  /// Amount of the contribution.
  RealColumn get amount => real()();

  /// Date of the contribution.
  DateTimeColumn get date => dateTime()();

  /// Note of the contribution.
  TextColumn get note => text().nullable()();
}
