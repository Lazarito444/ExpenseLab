import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/features/reports/domain/services/report_generator_service.dart';
import 'package:flutter/material.dart';

class ReportCategoryRow extends StatelessWidget {
  const ReportCategoryRow({required this.breakdown, super.key});

  final CategoryBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final verb = breakdown.isIncome ? 'earned' : 'spent';
    final changeStr = breakdown.percentChange != null
        ? '${breakdown.percentChange! >= 0 ? '+' : ''}${breakdown.percentChange!.toStringAsFixed(0)}%'
        : '-';

    final changeColor = breakdown.percentChange != null
        ? (breakdown.percentChange! >= 0
            ? (breakdown.isIncome ? appColors.incomeColor : appColors.expenseColor)
            : (breakdown.isIncome ? appColors.expenseColor : appColors.incomeColor))
        : appColors.secondaryLabel;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: breakdown.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: breakdown.isIncome
                  ? appColors.incomeColor.withValues(alpha: 0.1)
                  : appColors.expenseColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              breakdown.isIncome ? 'income' : 'expense',
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: breakdown.isIncome ? appColors.incomeColor : appColors.expenseColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              breakdown.categoryName,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.scrim,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${breakdown.amount.toStringAsFixed(2)} $verb',
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.scrim,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 48,
            child: Text(
              changeStr,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: changeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
