import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UpcomingPaymentsSection extends StatelessWidget {
  const UpcomingPaymentsSection({
    required this.payments,
    required this.currency,
    super.key,
  });

  final List<(AccountModel, DateTime, double?)> payments;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.home.upcoming_payments,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.colorScheme.scrim,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final (model, dueDate, minPay) in payments)
          _UpcomingPaymentTile(
            model: model,
            dueDate: dueDate,
            minimumPayment: minPay,
            currency: currency,
          ),
      ],
    );
  }
}

class _UpcomingPaymentTile extends StatelessWidget {
  const _UpcomingPaymentTile({
    required this.model,
    required this.dueDate,
    required this.minimumPayment,
    required this.currency,
  });

  final AccountModel model;
  final DateTime dueDate;
  final double? minimumPayment;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final t = context.t;
    final diff = dueDate.difference(DateTime.now()).inDays;
    final isUrgent = diff <= 3;
    final isSoon = diff <= 7;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.creditCardPay(model.id)),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: appColors.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUrgent
                ? context.colorScheme.error.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isUrgent
                    ? context.colorScheme.error.withValues(alpha: 0.12)
                    : isSoon
                        ? const Color(0xFFFF9500).withValues(alpha: 0.12)
                        : appColors.inputFill,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '${dueDate.day}',
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isUrgent
                          ? context.colorScheme.error
                          : isSoon
                              ? const Color(0xFFFF9500)
                              : appColors.primaryText,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(dueDate),
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isUrgent
                          ? context.colorScheme.error
                          : appColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.scrim,
                    ),
                  ),
                  if (minimumPayment != null)
                    Text(
                      '${t.accounts.credit_card_card.minimum_payment}: ${formatCurrency(minimumPayment!, model.currencyCode)}',
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 12,
                        color: appColors.secondaryLabel,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              formatCurrency(model.displayBalance, model.currencyCode),
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
