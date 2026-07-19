import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    required this.currency,
    required this.totalBalance,
    required this.changePct,
    super.key,
  });

  final Currency currency;
  final double totalBalance;
  final double? changePct;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final pct = changePct;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: totalBalance < 0
            ? context.appColors.balanceCardNegativeBg
            : context.appColors.balanceCardPositiveBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            t.home.total_balance,
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currency.format(totalBalance),
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 38,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          if (pct != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    pct >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    t.home.pct_this_month.replaceAll(
                      '{pct}',
                      '${pct >= 0 ? '+' : ''}${(pct * 100).toStringAsFixed(1)}%',
                    ),
                    style: const TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
