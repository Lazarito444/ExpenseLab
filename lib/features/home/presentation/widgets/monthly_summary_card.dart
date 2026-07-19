import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:flutter/material.dart';

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    required this.currency,
    required this.income,
    required this.expense,
    required this.savingsRate,
    super.key,
  });

  final Currency currency;
  final double income;
  final double expense;
  final double savingsRate;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
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
            t.home.monthly_summary,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.scrim,
            ),
          ),
          const SizedBox(height: 24),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child:                   SummaryColumn(
                    icon: Icons.arrow_downward_rounded,
                    iconColor: appColors.incomeColor,
                    label: t.home.income,
                    amount: currency.format(income),
                    amountColor: appColors.incomeColor,
                  ),
                ),
                Expanded(
                  child:                   SummaryColumn(
                    icon: Icons.arrow_upward_rounded,
                    iconColor: appColors.expenseColor,
                    label: t.home.expenses,
                    amount: currency.format(expense),
                    amountColor: appColors.expenseColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.home.savings_rate,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: appColors.secondaryLabel,
                ),
              ),
              Text(
                '${(savingsRate * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: savingsRate,
              minHeight: 8,
              backgroundColor: context.colorScheme.primary.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(context.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryColumn extends StatelessWidget {
  const SummaryColumn({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.amount,
    required this.amountColor,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String amount;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: amountColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: context.appColors.secondaryLabel,
            ),
          ),
        ],
      ),
    );
  }
}
