import 'package:expenselab/core/database/app_database.dart';

class SavingsContributionModel {
  const SavingsContributionModel({
    required this.id,
    required this.savingsGoalId,
    required this.amount,
    required this.date,
    this.note,
  });

  final String id;
  final String savingsGoalId;
  final double amount;
  final DateTime date;
  final String? note;

  factory SavingsContributionModel.fromSavingsContribution(
    SavingsContribution contribution,
  ) => SavingsContributionModel(
    id: contribution.id,
    savingsGoalId: contribution.savingsGoalId,
    amount: contribution.amount,
    date: contribution.date,
    note: contribution.note,
  );
}
