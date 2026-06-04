import 'package:expenselab/core/database/app_database.dart';

class SavingsGoalModel {
  const SavingsGoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.sourceAccountId,
    this.targetDate,
  });

  final String id;
  final String name;
  final double targetAmount;
  final String sourceAccountId;
  final DateTime? targetDate;

  bool get hasDeadline => targetDate != null;

  factory SavingsGoalModel.fromSavingsGoal(SavingsGoal goal) => SavingsGoalModel(
    id: goal.id,
    name: goal.name,
    targetAmount: goal.targetAmount,
    sourceAccountId: goal.sourceAccountId,
    targetDate: goal.targetDate,
  );
}
