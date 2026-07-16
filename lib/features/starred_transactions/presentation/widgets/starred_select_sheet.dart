import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:flutter/material.dart';

class StarredSelectSheet extends StatelessWidget {
  const StarredSelectSheet({
    required this.stars,
    required this.accounts,
    required this.allCategories,
    required this.currentType,
    required this.currentAmount,
    required this.currentAccountId,
    required this.currentToAccountId,
    required this.currentCategoryId,
    required this.currentNote,
    required this.onSave,
    super.key,
  });

  final List<StarredTransaction> stars;
  final List<AccountModel> accounts;
  final List<Category> allCategories;
  final TransactionType currentType;
  final double currentAmount;
  final String? currentAccountId;
  final String? currentToAccountId;
  final String? currentCategoryId;
  final String currentNote;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cs = context.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star_rounded, color: cs.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  t.starred_transactions.title,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: currentAccountId != null
                  ? () {
                      onSave();
                      Navigator.pop(context);
                    }
                  : null,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: currentAccountId != null
                        ? cs.primary.withValues(alpha: 0.3)
                        : cs.onSurfaceVariant.withValues(alpha: 0.15),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline_rounded,
                      color: currentAccountId != null ? cs.primary : cs.onSurfaceVariant.withValues(alpha: 0.4),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.starred_transactions.save_current,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: currentAccountId != null ? cs.primary : cs.onSurfaceVariant.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (stars.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_outline_rounded, size: 48, color: cs.onSurfaceVariant.withValues(alpha: 0.4)),
                      const SizedBox(height: 12),
                      Text(
                        t.starred_transactions.empty,
                        style: TextStyle(fontFamily: 'Epilogue', fontSize: 15, color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.starred_transactions.empty_subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Epilogue', fontSize: 12, color: cs.onSurfaceVariant.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: stars.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _StarredTile(
                    star: stars[i],
                    accounts: accounts,
                    allCategories: allCategories,
                    onTap: () => Navigator.pop(context, stars[i]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StarredTile extends StatelessWidget {
  const _StarredTile({
    required this.star,
    required this.accounts,
    required this.allCategories,
    required this.onTap,
  });

  final StarredTransaction star;
  final List<AccountModel> accounts;
  final List<Category> allCategories;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final appColors = context.appColors;

    final account = accounts.where((a) => a.id == star.accountId).firstOrNull;
    final cat = star.categoryId != null
        ? allCategories.where((c) => c.id == star.categoryId).firstOrNull
        : null;

    final iconData = cat != null ? iconFromName(cat.icon) : Icons.star_outline_rounded;
    final iconBgColor = cat != null
        ? Color(cat.color).withValues(alpha: 0.15)
        : cs.primaryContainer;
    final iconColor = cat != null ? Color(cat.color) : cs.primary;

    final label = star.note?.isNotEmpty == true
        ? star.note!
        : (cat?.name ?? context.t.transactions.no_category);

    final accountName = account?.name ?? context.t.transactions.no_account;
    final currencyCode = account?.currencyCode ?? 'USD';
    final sign = switch (star.type) {
      TransactionType.income => '+',
      TransactionType.expense => '-',
      TransactionType.transfer => '',
    };
    final amountColor = switch (star.type) {
      TransactionType.income => appColors.incomeColor,
      TransactionType.expense => appColors.expenseColor,
      TransactionType.transfer => cs.outline,
    };

    return Material(
      color: appColors.cardSurface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
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
                      label,
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.scrim,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      accountName,
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
              Text(
                '$sign$currencyCode ${star.amount.toStringAsFixed(star.amount.truncateToDouble() == star.amount ? 0 : 2)}',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
