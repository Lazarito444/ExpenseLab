import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Currency txCurrency(
  Transaction tx,
  Map<String, AccountModel> accountMap,
  Currency fallback,
) {
  final code = accountMap[tx.accountId]?.currencyCode;
  if (code == null) return fallback;
  return kSupportedCurrencies.firstWhere(
    (c) => c.code == code,
    orElse: () => fallback,
  );
}

String typeLabel(TransactionType type, Translations t) => switch (type) {
  TransactionType.income => t.transactions.tab_income,
  TransactionType.expense => t.transactions.tab_expense,
  TransactionType.transfer => t.transactions.tab_transfer,
};

String? localizedSystemNote(String? note, Translations t) => switch (note) {
  'Initial balance' => t.accounts.create.initial_balance_note,
  'Balance adjustment' => t.accounts.edit.balance_adjustment_note,
  'Saldo inicial' => t.accounts.create.initial_balance_note,
  'Ajuste de saldo' => t.accounts.edit.balance_adjustment_note,
  _ => note,
};

String formatTime(DateTime date, Translations t) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.isNegative) return DateFormat('MMM d').format(date);
  if (diff.inMinutes < 1) return t.home.minutes_ago.replaceAll('{minutes}', '0');
  if (diff.inHours < 1) return t.home.minutes_ago.replaceAll('{minutes}', '${diff.inMinutes}');
  if (diff.inHours < 24) return t.home.hours_ago.replaceAll('{hours}', '${diff.inHours}');
  final today = DateTime(now.year, now.month, now.day);
  final txDay = DateTime(date.year, date.month, date.day);
  if (today.difference(txDay).inDays == 1) return t.common.yesterday;
  return DateFormat('MMM d').format(date);
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.tx,
    required this.accountMap,
    required this.fallbackCurrency,
    required this.categoryMap,
    this.showTime = false,
    this.onTap,
    super.key,
  });

  final Transaction tx;
  final Map<String, AccountModel> accountMap;
  final Currency fallbackCurrency;
  final Map<String, Category> categoryMap;
  final bool showTime;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final appColors = context.appColors;
    final cat = tx.categoryId != null ? categoryMap[tx.categoryId] : null;

    final note = localizedSystemNote(tx.note, t);
    final primaryText = (note?.isNotEmpty ?? false) ? note! : (cat?.name ?? typeLabel(tx.type, t));
    final secondaryText = cat?.name ?? typeLabel(tx.type, t);

    final iconBgColor = cat != null
        ? Color(cat.color).withValues(alpha: 0.15)
        : context.colorScheme.primary.withValues(alpha: 0.12);

    final iconColor = cat != null
        ? Color(cat.color)
        : switch (tx.type) {
            TransactionType.income => appColors.incomeColor,
            TransactionType.expense => appColors.expenseColor,
            TransactionType.transfer => appColors.transferColor,
          };

    final iconData = cat != null
        ? iconFromName(cat.icon)
        : switch (tx.type) {
            TransactionType.income => Icons.arrow_downward_rounded,
            TransactionType.expense => Icons.arrow_upward_rounded,
            TransactionType.transfer => Icons.swap_horiz_rounded,
          };

    final txCur = txCurrency(tx, accountMap, fallbackCurrency);
    final sign = switch (tx.type) {
      TransactionType.income => '+',
      TransactionType.expense => '-',
      TransactionType.transfer => '',
    };
    final amountText = '$sign${txCur.format(tx.amount)}';
    final amountColor = switch (tx.type) {
      TransactionType.income => appColors.incomeColor,
      TransactionType.expense => appColors.expenseColor,
      TransactionType.transfer => context.colorScheme.outline,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: appColors.cardSurface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryText,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.scrim,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    showTime
                        ? secondaryText
                        : '$secondaryText · ${formatTime(tx.date, t)}',
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 12,
                      color: appColors.secondaryLabel,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountText,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                  ),
                ),
                if (showTime) ...[
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('hh:mm a').format(tx.date),
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 11,
                      color: amountColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.colorScheme.scrim,
          ),
        ),
      ],
    );
  }
}
