import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/features/reports/domain/services/report_generator_service.dart';
import 'package:flutter/material.dart';

class ReportBudgetsSection extends StatelessWidget {
  const ReportBudgetsSection({required this.budgets, super.key});

  final List<BudgetReportItem> budgets;

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
            'Budgets',
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.scrim,
            ),
          ),
          const SizedBox(height: 16),
          if (budgets.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No budgets',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  color: context.colorScheme.outline,
                ),
              ),
            )
          else
            ...budgets.map((b) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: _BudgetRow(item: b),
            )),
        ],
      ),
    );
  }
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow({required this.item});

  final BudgetReportItem item;

  @override
  Widget build(BuildContext context) {
    final statusColor = item.percentageUsed > 100
        ? const Color(0xFFD9534F)
        : item.percentageUsed > 80
            ? Colors.orange
            : const Color(0xFF4CAF50);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: item.categoryColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.categoryName,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.colorScheme.scrim,
                ),
              ),
            ),
            Text(
              '\$${item.spentAmount.toStringAsFixed(0)} / \$${item.budgetAmount.toStringAsFixed(0)}',
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
            value: (item.percentageUsed / 100).clamp(0.0, 1.0),
            backgroundColor: context.colorScheme.primary.withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation(statusColor),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${item.percentageUsed.toStringAsFixed(0)}% used',
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontSize: 11,
            color: statusColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
