import 'package:expenselab/core/database/app_database.dart';

class BudgetModel {
  const BudgetModel({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.startDate,
    this.endDate,
    this.rrule,
  });

  final String id;
  final String categoryId;
  final double amount;
  final DateTime startDate;
  final DateTime? endDate;
  final String? rrule;

  bool get isRecurring => rrule != null;
  bool get isOpenEnded => endDate == null;

  factory BudgetModel.fromBudget(Budget budget) => BudgetModel(
    id: budget.id,
    categoryId: budget.categoryId,
    amount: budget.amount,
    startDate: budget.startDate,
    endDate: budget.endDate,
    rrule: budget.rrule,
  );
}
