import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';

class Budgets extends Table with SoftDeleteTable {
  /// ID of the category.
  TextColumn get categoryId => text().references(Categories, #id)();

  /// Budgeted amount.
  RealColumn get amount => real()();

  /// Start date of the budget.
  DateTimeColumn get startDate => dateTime()();

  /// End date of the budget, null means it will never end.
  DateTimeColumn get endDate => dateTime().nullable()();

  /// Recurrence rule, null means it will never recur.
  TextColumn get rrule => text().nullable()();
}
