import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/features/starred_transactions/providers/starred_transactions_providers.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StarredTransactionsScreen extends ConsumerWidget {
  const StarredTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final cs = context.colorScheme;
    final starsAsync = ref.watch(starredTransactionsStreamProvider);
    final accounts = ref.watch(accountModelsProvider);
    final allCategories = ref.watch(categoriesProvider).value ?? [];

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: t.starred_transactions.title,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: starsAsync.when(
        data: (stars) {
          if (stars.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_outline_rounded, size: 64, color: cs.onSurfaceVariant.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    t.starred_transactions.empty,
                    style: TextStyle(fontFamily: 'Epilogue', fontSize: 16, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.starred_transactions.empty_subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Epilogue', fontSize: 13, color: cs.onSurfaceVariant.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: stars.length,
            itemBuilder: (context, i) => _StarredItemTile(
              star: stars[i],
              accounts: accounts,
              allCategories: allCategories,
              onTap: () => context.push(AppRoutes.addTransactionWithStarred(stars[i].id)),
              onDelete: () => _deleteStar(context, ref, stars[i].id, t),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('$err')),
      ),
    );
  }
}

Future<void> _deleteStar(BuildContext context, WidgetRef ref, String id, Translations t) async {
  await ref.read(starredTransactionsRepositoryProvider).delete(id);
}

class _StarredItemTile extends StatelessWidget {
  const _StarredItemTile({
    required this.star,
    required this.accounts,
    required this.allCategories,
    required this.onTap,
    required this.onDelete,
  });

  final StarredTransaction star;
  final List<AccountModel> accounts;
  final List<Category> allCategories;
  final VoidCallback onTap;
  final VoidCallback onDelete;

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey(star.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async => true,
        onDismissed: (_) => onDelete(),
        background: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD9534F),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
        ),
        child: Material(
          color: appColors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: appColors.inputBorder, width: 1.5),
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
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, color: appColors.secondaryLabel, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
