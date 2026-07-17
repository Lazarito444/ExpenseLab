import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/budgets/domain/budget_period.dart';
import 'package:expenselab/features/budgets/domain/models/budget_model.dart';
import 'package:expenselab/features/reports/data/datasources/reports_local_datasource.dart';
import 'package:expenselab/features/savings/domain/models/savings_contribution_model.dart';
import 'package:expenselab/features/savings/domain/models/savings_goal_model.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:flutter/material.dart';

class CategoryBreakdown {
  const CategoryBreakdown({
    required this.isIncome,
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.previousMonthAmount,
    required this.color,
  });

  final bool isIncome;
  final String categoryName;
  final double amount;
  final double percentage;
  final double? previousMonthAmount;
  final Color color;

  double? get percentChange =>
      previousMonthAmount != null && previousMonthAmount! > 0
          ? ((amount - previousMonthAmount!) / previousMonthAmount!) * 100
          : null;
}

class BudgetReportItem {
  const BudgetReportItem({
    required this.categoryName,
    required this.budgetAmount,
    required this.spentAmount,
    required this.categoryColor,
  });

  final String categoryName;
  final double budgetAmount;
  final double spentAmount;
  final Color categoryColor;

  double get percentageUsed => budgetAmount > 0 ? (spentAmount / budgetAmount) * 100 : 0;
}

class SavingsGoalReportItem {
  const SavingsGoalReportItem({
    required this.goalName,
    required this.targetAmount,
    required this.savedAmount,
  });

  final String goalName;
  final double targetAmount;
  final double savedAmount;

  double get percentageSaved => targetAmount > 0 ? (savedAmount / targetAmount) * 100 : 0;
}

class ReportData {
  const ReportData({
    required this.categoryBreakdowns,
    required this.totalIncome,
    required this.totalExpense,
    required this.cashFlowWeeklyIncome,
    required this.cashFlowWeeklyExpense,
    required this.budgets,
    required this.savingsGoals,
  });

  final List<CategoryBreakdown> categoryBreakdowns;
  final double totalIncome;
  final double totalExpense;
  final List<double> cashFlowWeeklyIncome;
  final List<double> cashFlowWeeklyExpense;
  final List<BudgetReportItem> budgets;
  final List<SavingsGoalReportItem> savingsGoals;

  double get netIncome => totalIncome - totalExpense;
  double get savingsRate => totalIncome > 0 ? (netIncome / totalIncome).clamp(0.0, 1.0) : 0.0;
}

class ReportGeneratorService {
  ReportGeneratorService({
    required ReportsLocalDataSource reportsDataSource,
    required List<Transaction> allTransactions,
    required List<Category> allCategories,
    required List<BudgetModel> allBudgets,
    required List<SavingsGoalModel> allSavingsGoals,
    required List<SavingsContributionModel> allContributions,
  }) : _reportsDataSource = reportsDataSource,
       _allTransactions = allTransactions,
       _allCategories = allCategories,
       _allBudgets = allBudgets,
       _allSavingsGoals = allSavingsGoals,
       _allContributions = allContributions;

  final ReportsLocalDataSource _reportsDataSource;
  final List<Transaction> _allTransactions;
  final List<Category> _allCategories;
  final List<BudgetModel> _allBudgets;
  final List<SavingsGoalModel> _allSavingsGoals;
  final List<SavingsContributionModel> _allContributions;

  static List<Transaction> _transactionsForMonth(List<Transaction> txs, int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59);
    return txs
        .where((t) => t.isVisible && !t.date.isBefore(start) && !t.date.isAfter(end))
        .toList();
  }

  Future<void> ensureReportForLastMonth() async {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    final existing = await _reportsDataSource.findByYearMonth(lastMonth.year, lastMonth.month);
    if (existing != null) return;
    await _reportsDataSource.create(
      ReportsCompanion(
        year: Value(lastMonth.year),
        month: Value(lastMonth.month),
      ),
    );
  }

  ReportData buildReportData(int year, int month) {
    final monthTxs = _transactionsForMonth(_allTransactions, year, month);
    final prevMonthTxs = _transactionsForMonth(_allTransactions, year, month - 1);

    final catMap = {for (final c in _allCategories) c.id: c};

    final incomeByCat = <String, double>{};
    final expenseByCat = <String, double>{};
    double totalIncome = 0, totalExpense = 0;

    for (final tx in monthTxs) {
      if (tx.categoryId == null) continue;
      if (tx.type == TransactionType.income) {
        incomeByCat[tx.categoryId!] = (incomeByCat[tx.categoryId!] ?? 0) + tx.amount;
        totalIncome += tx.amount;
      } else if (tx.type == TransactionType.expense) {
        expenseByCat[tx.categoryId!] = (expenseByCat[tx.categoryId!] ?? 0) + tx.amount;
        totalExpense += tx.amount;
      }
    }

    final prevIncomeByCat = <String, double>{};
    final prevExpenseByCat = <String, double>{};
    for (final tx in prevMonthTxs) {
      if (tx.categoryId == null) continue;
      if (tx.type == TransactionType.income) {
        prevIncomeByCat[tx.categoryId!] = (prevIncomeByCat[tx.categoryId!] ?? 0) + tx.amount;
      } else if (tx.type == TransactionType.expense) {
        prevExpenseByCat[tx.categoryId!] = (prevExpenseByCat[tx.categoryId!] ?? 0) + tx.amount;
      }
    }

    final breakdowns = <CategoryBreakdown>[];

    for (final entry in expenseByCat.entries) {
      final cat = catMap[entry.key];
      breakdowns.add(CategoryBreakdown(
        isIncome: false,
        categoryName: cat?.name ?? 'Unknown',
        amount: entry.value,
        percentage: totalExpense > 0 ? entry.value / totalExpense : 0,
        previousMonthAmount: prevExpenseByCat[entry.key],
        color: cat != null ? Color(cat.color) : Colors.grey,
      ));
    }

    for (final entry in incomeByCat.entries) {
      final cat = catMap[entry.key];
      breakdowns.add(CategoryBreakdown(
        isIncome: true,
        categoryName: cat?.name ?? 'Unknown',
        amount: entry.value,
        percentage: totalIncome > 0 ? entry.value / totalIncome : 0,
        previousMonthAmount: prevIncomeByCat[entry.key],
        color: cat != null ? Color(cat.color) : Colors.grey,
      ));
    }

    breakdowns.sort((a, b) => b.amount.compareTo(a.amount));

    final weeklyIncome = <double>[0, 0, 0, 0];
    final weeklyExpense = <double>[0, 0, 0, 0];
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final weekRanges = [
      (1, 7),
      (8, 14),
      (15, 21),
      (22, daysInMonth),
    ];
    for (final tx in monthTxs) {
      for (int w = 0; w < 4; w++) {
        final (start, end) = weekRanges[w];
        if (tx.date.day >= start && tx.date.day <= end) {
          if (tx.type == TransactionType.income) {
            weeklyIncome[w] += tx.amount;
          } else if (tx.type == TransactionType.expense) {
            weeklyExpense[w] += tx.amount;
          }
          break;
        }
      }
    }

    final budgets = <BudgetReportItem>[];
    for (final budget in _allBudgets) {
      final cat = catMap[budget.categoryId];
      double spent = 0;
      for (final tx in monthTxs) {
        if (tx.categoryId == budget.categoryId && tx.type == TransactionType.expense) {
          spent += tx.amount;
        }
      }
      final budgetAmount = budget.rrule != null
          ? (BudgetPeriod.fromRrule(budget.rrule!) == BudgetPeriod.monthly
              ? budget.amount
              : budget.amount)
          : budget.amount;
      budgets.add(BudgetReportItem(
        categoryName: cat?.name ?? 'Unknown',
        budgetAmount: budgetAmount,
        spentAmount: spent,
        categoryColor: cat != null ? Color(cat.color) : Colors.grey,
      ));
    }
    budgets.sort((a, b) => (b.percentageUsed).compareTo(a.percentageUsed));

    final savingsByGoal = <String, double>{};
    for (final goal in _allSavingsGoals) {
      savingsByGoal[goal.id] = 0;
    }
    for (final c in _allContributions) {
      savingsByGoal[c.savingsGoalId] =
          (savingsByGoal[c.savingsGoalId] ?? 0) + c.amount;
    }
    final savingsGoals = _allSavingsGoals.map((g) => SavingsGoalReportItem(
      goalName: g.name,
      targetAmount: g.targetAmount,
      savedAmount: savingsByGoal[g.id] ?? 0,
    )).toList();

    return ReportData(
      categoryBreakdowns: breakdowns,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      cashFlowWeeklyIncome: weeklyIncome,
      cashFlowWeeklyExpense: weeklyExpense,
      budgets: budgets,
      savingsGoals: savingsGoals,
    );
  }
}
