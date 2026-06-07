import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/budgets/providers/budgets_providers.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = context.t;
    final currency = ref.watch(currencyProvider);
    final selectedMonth = ref.watch(selectedBudgetMonthProvider);

    final budgets = ref.watch(budgetsProvider).value ?? [];
    final allCategories = ref.watch(categoriesProvider).value ?? [];
    final transactions = ref.watch(transactionsProvider).value ?? [];
    final isLoading = ref.watch(budgetsProvider).isLoading;

    final categoryMap = {for (final c in allCategories) c.id: c};

    final monthlySpending = <String, double>{};
    final monthlyCount = <String, int>{};
    for (final tx in transactions) {
      if (tx.type == TransactionType.expense && tx.date.year == selectedMonth.year && tx.date.month == selectedMonth.month && tx.categoryId != null) {
        final cid = tx.categoryId!;
        monthlySpending[cid] = (monthlySpending[cid] ?? 0) + tx.amount;
        monthlyCount[cid] = (monthlyCount[cid] ?? 0) + 1;
      }
    }

    final totalSpent = budgets.fold(0.0, (s, b) => s + (monthlySpending[b.categoryId] ?? 0.0));
    final totalBudget = budgets.fold(0.0, (s, b) => s + b.amount);
    final totalRemaining = totalBudget - totalSpent;
    final overallPct = totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
      floatingActionButton: FloatingActionButton(
        heroTag: 'budgets_fab',
        onPressed: () => context.push(AppRoutes.budgetsCreate),
        backgroundColor: context.colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                children: [
                  // ── Header ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            t.budgets.title,
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                              color: isDark ? Colors.white : context.colorScheme.primary,
                            ),
                          ),
                        ),
                        _MonthSelector(
                          selectedMonth: selectedMonth,
                          isDark: isDark,
                          onPrev: () => ref.read(selectedBudgetMonthProvider.notifier).previous(),
                          onNext: () => ref.read(selectedBudgetMonthProvider.notifier).next(),
                        ),
                      ],
                    ),
                  ),

                  if (budgets.isEmpty) ...[
                    _EmptyState(isDark: isDark, t: t),
                  ] else ...[
                    // ── Summary card ──────────────────────────────────
                    _SummaryCard(
                      currency: currency,
                      totalSpent: totalSpent,
                      totalBudget: totalBudget,
                      totalRemaining: totalRemaining,
                      overallPct: overallPct,
                      isDark: isDark,
                      t: t,
                    ),
                    const SizedBox(height: 24),

                    // ── Categories header ─────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.budgets.categories,
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: isDark ? Colors.white : const Color(0xFF0F1E36),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.budgetsCreate),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                t.common.edit,
                                style: TextStyle(
                                  fontFamily: 'Epilogue',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: context.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.edit_outlined,
                                size: 14,
                                color: context.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Budget cards ──────────────────────────────────
                    ...budgets.map((budget) {
                      final cat = categoryMap[budget.categoryId];
                      final spent = monthlySpending[budget.categoryId] ?? 0.0;
                      final count = monthlyCount[budget.categoryId] ?? 0;
                      final progress = budget.amount > 0 ? spent / budget.amount : 0.0;
                      final catColor = cat != null ? Color(cat.color) : context.colorScheme.primary;
                      final displayName = cat?.name ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _BudgetCard(
                          displayName: displayName,
                          categoryIcon: cat != null ? iconFromName(cat.icon) : Icons.category_outlined,
                          categoryColor: catColor,
                          spent: spent,
                          budgetAmount: budget.amount,
                          transactionCount: count,
                          progress: progress,
                          currency: currency,
                          isDark: isDark,
                          t: t,
                          onTap: () => context.push(AppRoutes.budgetEdit(budget.id)),
                        ),
                      );
                    }),
                  ],
                ],
              ),
      ),
    );
  }
}

// ── Month selector ────────────────────────────────────────────────────────────

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.selectedMonth,
    required this.isDark,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime selectedMonth;
  final bool isDark;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onPrev,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(Icons.chevron_left_rounded, size: 18, color: context.colorScheme.primary),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              toBeginningOfSentenceCase(DateFormat('MMMM', LocaleSettings.currentLocale.languageTag).format(selectedMonth)),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.colorScheme.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onNext,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(Icons.chevron_right_rounded, size: 18, color: context.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark, required this.t});

  final bool isDark;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 72,
                color: context.colorScheme.primary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 20),
              Text(
                t.budgets.no_budgets,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: isDark ? Colors.white : const Color(0xFF0F1E36),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                t.budgets.no_budgets_subtitle,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.currency,
    required this.totalSpent,
    required this.totalBudget,
    required this.totalRemaining,
    required this.overallPct,
    required this.isDark,
    required this.t,
  });

  final Currency currency;
  final double totalSpent;
  final double totalBudget;
  final double totalRemaining;
  final double overallPct;
  final bool isDark;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    final isOver = totalSpent > totalBudget;
    final pct = (overallPct * 100).round();
    final statusLabel = isOver
        ? t.budgets.over_budget
        : overallPct >= 0.8
        ? t.budgets.almost
        : t.budgets.on_track;
    final statusColor = isOver
        ? Colors.red.shade600
        : overallPct >= 0.8
        ? Colors.orange.shade700
        : context.colorScheme.primary;
    final ofLimitText = t.budgets.of_limit.replaceAll('{pct}', pct.toString()).replaceAll('{limit}', currency.format(totalBudget));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2420) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.budgets.total_spent,
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                        color: context.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currency.format(totalSpent),
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        color: isDark ? Colors.white : const Color(0xFF0F1E36),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    t.budgets.remaining,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      color: context.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currency.format(totalRemaining.abs()),
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      color: isOver ? Colors.red.shade600 : (isDark ? Colors.white : const Color(0xFF0F1E36)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: overallPct,
              minHeight: 8,
              backgroundColor: context.colorScheme.primary.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(
                isOver ? Colors.red.shade600 : context.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ofLimitText,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : const Color(0xFF9EAEA2),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Budget card ───────────────────────────────────────────────────────────────

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.displayName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.spent,
    required this.budgetAmount,
    required this.transactionCount,
    required this.progress,
    required this.currency,
    required this.isDark,
    required this.t,
    required this.onTap,
  });

  final String displayName;
  final IconData categoryIcon;
  final Color categoryColor;
  final double spent;
  final double budgetAmount;
  final int transactionCount;
  final double progress;
  final Currency currency;
  final bool isDark;
  final Translations t;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOver = spent > budgetAmount;
    final barColor = isOver ? Colors.red.shade600 : categoryColor;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final overAmount = spent - budgetAmount;
    final rightText = isOver ? t.budgets.over_by.replaceAll('{amount}', currency.format(overAmount)) : t.budgets.of_amount.replaceAll('{amount}', currency.format(budgetAmount));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2420) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Category icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(categoryIcon, color: categoryColor, size: 24),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: isDark ? Colors.white : const Color(0xFF0F1E36),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currency.format(spent),
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: isOver ? Colors.red.shade600 : (isDark ? Colors.white : const Color(0xFF0F1E36)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.budgets.transaction_count(n: transactionCount),
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 12,
                          color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                        ),
                      ),
                      Text(
                        rightText,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 12,
                          fontWeight: isOver ? FontWeight.w600 : FontWeight.w400,
                          color: isOver ? Colors.red.shade600 : (isDark ? Colors.white38 : const Color(0xFF9EAEA2)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: clampedProgress,
                      minHeight: 6,
                      backgroundColor: barColor.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation(barColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
