import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/features/reports/domain/services/report_generator_service.dart';
import 'package:flutter/material.dart';

class ReportSavingsSection extends StatelessWidget {
  const ReportSavingsSection({required this.savingsGoals, super.key});

  final List<SavingsGoalReportItem> savingsGoals;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Savings Goals',
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.scrim,
            ),
          ),
          const SizedBox(height: 16),
          if (savingsGoals.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No savings goals',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  color: context.colorScheme.outline,
                ),
              ),
            )
          else
            ...savingsGoals.map((g) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: _SavingsGoalRow(goal: g),
            )),
        ],
      ),
    );
  }
}

class _SavingsGoalRow extends StatelessWidget {
  const _SavingsGoalRow({required this.goal});

  final SavingsGoalReportItem goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flag_outlined, size: 16, color: context.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                goal.goalName,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.colorScheme.scrim,
                ),
              ),
            ),
            Text(
              '\$${goal.savedAmount.toStringAsFixed(0)} / \$${goal.targetAmount.toStringAsFixed(0)}',
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.colorScheme.scrim,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (goal.percentageSaved / 100).clamp(0.0, 1.0),
            backgroundColor: context.colorScheme.primary.withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation(context.colorScheme.primary),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${goal.percentageSaved.toStringAsFixed(0)}% of target',
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontSize: 11,
            color: context.appColors.secondaryLabel,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
