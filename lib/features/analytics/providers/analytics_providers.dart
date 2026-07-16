import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CashFlowPoint {
  const CashFlowPoint({
    required this.label,
    required this.income,
    required this.expense,
  });

  final String label;
  final double income;
  final double expense;
}

class CategoryShare {
  const CategoryShare({
    required this.name,
    required this.color,
    required this.amount,
    required this.percentage,
  });

  final String name;
  final Color color;
  final double amount;
  final double percentage;
}

final analyticsMonthProvider = NotifierProvider<AnalyticsMonthNotifier, DateTime>(
  AnalyticsMonthNotifier.new,
);

class AnalyticsMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void previous() => state = DateTime(state.year, state.month - 1);
  void next() => state = DateTime(state.year, state.month + 1);
  void setMonth(DateTime month) => state = month;
}

final cashFlowDataProvider = Provider.family<List<CashFlowPoint>, DateTime>((ref, month) {
  final txs = ref.watch(visibleTransactionsProvider);
  final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
  final weekRanges = [
    (start: 1, end: 7),
    (start: 8, end: 14),
    (start: 15, end: 21),
    (start: 22, end: daysInMonth),
  ];

  return List.generate(4, (i) {
    final range = weekRanges[i];
    final weekStart = DateTime(month.year, month.month, range.start);
    final weekEnd = DateTime(month.year, month.month, range.end, 23, 59, 59);

    double income = 0.0, expense = 0.0;
    for (final tx in txs) {
      if (tx.date.isBefore(weekStart) || tx.date.isAfter(weekEnd)) continue;
      if (tx.type == TransactionType.income) income += tx.amount;
      if (tx.type == TransactionType.expense) expense += tx.amount;
    }

    return CashFlowPoint(label: 'W${i + 1}', income: income, expense: expense);
  });
});

final analyticsNetIncomeProvider = Provider<double>((ref) {
  final month = ref.watch(analyticsMonthProvider);
  final txs = ref.watch(visibleTransactionsProvider);
  final start = DateTime(month.year, month.month, 1);
  final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
  double income = 0, expense = 0;
  for (final tx in txs) {
    if (tx.date.isBefore(start) || tx.date.isAfter(end)) continue;
    if (tx.type == TransactionType.income) income += tx.amount;
    if (tx.type == TransactionType.expense) expense += tx.amount;
  }
  return income - expense;
});

final analyticsSavingsRateProvider = Provider<double>((ref) {
  final month = ref.watch(analyticsMonthProvider);
  final txs = ref.watch(visibleTransactionsProvider);
  final start = DateTime(month.year, month.month, 1);
  final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
  double income = 0, expense = 0;
  for (final tx in txs) {
    if (tx.date.isBefore(start) || tx.date.isAfter(end)) continue;
    if (tx.type == TransactionType.income) income += tx.amount;
    if (tx.type == TransactionType.expense) expense += tx.amount;
  }
  if (income <= 0) return 0.0;
  return ((income - expense) / income).clamp(0.0, 1.0);
});

final spendingByCategoryProvider = Provider.family<List<CategoryShare>, DateTime>((ref, month) {
  final txs = ref.watch(visibleTransactionsProvider);
  return ref
      .watch(categoriesProvider)
      .when(
        data: (cats) {
          final start = DateTime(month.year, month.month, 1);
          final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
          final catMap = {for (final c in cats) c.id: c};
          final spending = <String, double>{};

          for (final tx in txs) {
            if (tx.type != TransactionType.expense) continue;
            if (tx.date.isBefore(start) || tx.date.isAfter(end)) continue;
            if (tx.categoryId == null) continue;
            spending[tx.categoryId!] = (spending[tx.categoryId!] ?? 0) + tx.amount;
          }

          final total = spending.values.fold(0.0, (a, b) => a + b);
          if (total == 0) return <CategoryShare>[];

          return spending.entries
              .map((e) {
                final cat = catMap[e.key];
                if (cat == null) return null;
                return CategoryShare(
                  name: cat.name,
                  color: Color(cat.color),
                  amount: e.value,
                  percentage: e.value / total,
                );
              })
              .whereType<CategoryShare>()
              .toList()
            ..sort((a, b) => b.amount.compareTo(a.amount));
        },
        loading: () => <CategoryShare>[],
        error: (_, _) => <CategoryShare>[],
      );
});

final incomeByCategoryProvider = Provider.family<List<CategoryShare>, DateTime>((ref, month) {
  final txs = ref.watch(visibleTransactionsProvider);
  return ref
      .watch(categoriesProvider)
      .when(
        data: (cats) {
          final start = DateTime(month.year, month.month, 1);
          final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
          final catMap = {for (final c in cats) c.id: c};
          final incomeMap = <String, double>{};

          for (final tx in txs) {
            if (tx.type != TransactionType.income) continue;
            if (tx.date.isBefore(start) || tx.date.isAfter(end)) continue;
            if (tx.categoryId == null) continue;
            incomeMap[tx.categoryId!] = (incomeMap[tx.categoryId!] ?? 0) + tx.amount;
          }

          final total = incomeMap.values.fold(0.0, (a, b) => a + b);
          if (total == 0) return <CategoryShare>[];

          return incomeMap.entries
              .map((e) {
                final cat = catMap[e.key];
                if (cat == null) return null;
                return CategoryShare(
                  name: cat.name,
                  color: Color(cat.color),
                  amount: e.value,
                  percentage: e.value / total,
                );
              })
              .whereType<CategoryShare>()
              .toList()
            ..sort((a, b) => b.amount.compareTo(a.amount));
        },
        loading: () => <CategoryShare>[],
        error: (_, _) => <CategoryShare>[],
      );
});
