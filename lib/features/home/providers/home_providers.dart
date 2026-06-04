import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks whether the home screen is in calendar view (true) or dashboard (false).
///
/// Awaits [settingsProvider] on first build so the correct view is shown
/// immediately — no flash of the wrong view while SharedPreferences loads.
/// Mid-session toggles are remembered via [_sessionOverride] so that changing
/// other settings (currency, theme, etc.) does not reset the current view.
class HomeCalendarNotifier extends AsyncNotifier<bool> {
  bool? _sessionOverride;

  @override
  Future<bool> build() async {
    final settings = await ref.watch(settingsProvider.future);
    return _sessionOverride ?? settings.defaultHomeIsCalendar;
  }

  void toggle() {
    _sessionOverride = !(state.value ?? false);
    state = AsyncData(_sessionOverride!);
  }
}

final homeIsCalendarProvider =
    AsyncNotifierProvider<HomeCalendarNotifier, bool>(HomeCalendarNotifier.new);

({DateTime start, DateTime end}) _thisMonthRange() {
  final now = DateTime.now();
  return (
    start: DateTime(now.year, now.month, 1),
    end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
  );
}

/// Sum of all income transactions in the current calendar month.
final monthlyIncomeProvider = Provider<double>((ref) {
  return ref.watch(transactionsProvider).when(
    data: (txs) {
      final r = _thisMonthRange();
      return txs
          .where((t) =>
              t.type == TransactionType.income &&
              !t.date.isBefore(r.start) &&
              !t.date.isAfter(r.end))
          .fold(0.0, (sum, t) => sum + t.amount);
    },
    loading: () => 0.0,
    error: (_, _) => 0.0,
  );
});

/// Sum of all expense transactions in the current calendar month.
final monthlyExpenseProvider = Provider<double>((ref) {
  return ref.watch(transactionsProvider).when(
    data: (txs) {
      final r = _thisMonthRange();
      return txs
          .where((t) =>
              t.type == TransactionType.expense &&
              !t.date.isBefore(r.start) &&
              !t.date.isAfter(r.end))
          .fold(0.0, (sum, t) => sum + t.amount);
    },
    loading: () => 0.0,
    error: (_, _) => 0.0,
  );
});

/// Savings rate = (income − expense) / income, clamped to [0, 1].
/// Returns 0 when there is no income this month.
final savingsRateProvider = Provider<double>((ref) {
  final income = ref.watch(monthlyIncomeProvider);
  final expense = ref.watch(monthlyExpenseProvider);
  if (income <= 0) return 0.0;
  return ((income - expense) / income).clamp(0.0, 1.0);
});

/// The 5 most recent transactions across all accounts, sorted newest-first.
final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  return ref.watch(transactionsProvider).when(
    data: (txs) {
      final sorted = [...txs]..sort((a, b) => b.date.compareTo(a.date));
      return sorted.take(5).toList();
    },
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Approximate monthly balance change as a fraction of total net worth.
/// e.g. 0.024 means +2.4%. Returns null when net worth is zero.
final monthlyBalanceChangePctProvider = Provider<double?>((ref) {
  final income = ref.watch(monthlyIncomeProvider);
  final expense = ref.watch(monthlyExpenseProvider);
  final netWorth = ref.watch(totalNetWorthProvider);
  if (netWorth == 0) return null;
  return (income - expense) / netWorth.abs();
});

/// All transactions grouped by their calendar day (time stripped).
/// Used by the calendar view to mark days that have transactions.
final transactionsByDateProvider = Provider<Map<DateTime, List<Transaction>>>((ref) {
  return ref.watch(transactionsProvider).when(
    data: (txs) {
      final map = <DateTime, List<Transaction>>{};
      for (final tx in txs) {
        final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
        map.putIfAbsent(day, () => []).add(tx);
      }
      return map;
    },
    loading: () => {},
    error: (_, _) => {},
  );
});
