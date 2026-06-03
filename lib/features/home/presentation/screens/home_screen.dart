import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/features/home/providers/home_providers.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Returns the [Currency] for [tx]'s source account, falling back to [fallback].
Currency _txCurrency(
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

String _typeLabel(TransactionType type, Translations t) => switch (type) {
  TransactionType.income => t.transactions.tab_income,
  TransactionType.expense => t.transactions.tab_expense,
  TransactionType.transfer => t.transactions.tab_transfer,
};

String _formatTime(DateTime date, Translations t) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.isNegative) return DateFormat('MMM d').format(date);
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  final today = DateTime(now.year, now.month, now.day);
  final txDay = DateTime(date.year, date.month, date.day);
  if (today.difference(txDay).inDays == 1) return t.common.yesterday;
  return DateFormat('MMM d').format(date);
}

// ── Screen ───────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime _calendarMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final isCalendarView = ref.watch(homeIsCalendarProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: isCalendarView
          ? _CalendarView(
              key: const ValueKey('calendar'),
              calendarMonth: _calendarMonth,
              selectedDay: _selectedDay,
              onMonthChanged: (m) => setState(() => _calendarMonth = m),
              onDaySelected: (d) => setState(() => _selectedDay = d),
            )
          : const _DashboardView(key: ValueKey('dashboard')),
    );
  }
}

// ── Dashboard view ───────────────────────────────────────────────────────────

class _DashboardView extends ConsumerWidget {
  const _DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final currency = ref.watch(currencyProvider);
    final totalBalance = ref.watch(totalNetWorthProvider);
    final monthlyIncome = ref.watch(monthlyIncomeProvider);
    final monthlyExpense = ref.watch(monthlyExpenseProvider);
    final savingsRate = ref.watch(savingsRateProvider);
    final changePct = ref.watch(monthlyBalanceChangePctProvider);
    final recentTxs = ref.watch(recentTransactionsProvider);
    final categoryMap = ref
        .watch(categoriesProvider)
        .when(
          data: (cats) => {for (final c in cats) c.id: c},
          loading: () => <String, Category>{},
          error: (_, _) => <String, Category>{},
        );
    final accountMap = {for (final a in ref.watch(accountModelsProvider)) a.id: a};

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        _BalanceCard(
          currency: currency,
          totalBalance: totalBalance,
          changePct: changePct,
        ),
        const SizedBox(height: 20),
        _MonthlySummaryCard(
          currency: currency,
          income: monthlyIncome,
          expense: monthlyExpense,
          savingsRate: savingsRate,
        ),
        const SizedBox(height: 24),
        _SectionHeader(
          title: t.home.recent_transactions,
        ),
        const SizedBox(height: 12),
        if (recentTxs.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                t.home.no_transactions,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  color: context.colorScheme.outline,
                ),
              ),
            ),
          )
        else
          ...recentTxs.map(
            (tx) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _TransactionTile(
                tx: tx,
                accountMap: accountMap,
                fallbackCurrency: currency,
                categoryMap: categoryMap,
                onTap: () => context.push(AppRoutes.transactionEdit(tx.id)),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Balance card ─────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.currency,
    required this.totalBalance,
    required this.changePct,
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
        color: context.colorScheme.primary,
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

// ── Monthly summary card ──────────────────────────────────────────────────────

class _MonthlySummaryCard extends StatelessWidget {
  const _MonthlySummaryCard({
    required this.currency,
    required this.income,
    required this.expense,
    required this.savingsRate,
  });

  final Currency currency;
  final double income;
  final double expense;
  final double savingsRate;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? context.colorScheme.surfaceContainerHigh : Colors.white,
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
                  child: _SummaryColumn(
                    icon: Icons.arrow_downward_rounded,
                    iconColor: Colors.green.shade600,
                    label: t.home.income,
                    amount: currency.format(income),
                    amountColor: Colors.green.shade700,
                  ),
                ),
                Expanded(
                  child: _SummaryColumn(
                    icon: Icons.arrow_upward_rounded,
                    iconColor: Colors.red.shade500,
                    label: t.home.expenses,
                    amount: currency.format(expense),
                    amountColor: Colors.red.shade600,
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
                style: const TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: Color(0xFF9EAEA2),
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

class _SummaryColumn extends StatelessWidget {
  const _SummaryColumn({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.amount,
    required this.amountColor,
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
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9EAEA2),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
  });

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

// ── Transaction tile ──────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.tx,
    required this.accountMap,
    required this.fallbackCurrency,
    required this.categoryMap,
    this.showTime = false,
    this.onTap,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = tx.categoryId != null ? categoryMap[tx.categoryId] : null;

    final primaryText = (tx.note?.isNotEmpty ?? false) ? tx.note! : (cat?.name ?? _typeLabel(tx.type, t));

    final secondaryText = cat?.name ?? _typeLabel(tx.type, t);

    final iconBgColor = cat != null ? Color(cat.color).withValues(alpha: 0.15) : context.colorScheme.primary.withValues(alpha: 0.12);

    final iconColor = cat != null
        ? Color(cat.color)
        : switch (tx.type) {
            TransactionType.income => Colors.green.shade600,
            TransactionType.expense => Colors.red.shade500,
            TransactionType.transfer => Colors.grey.shade600,
          };

    final iconData = cat != null
        ? iconFromName(cat.icon)
        : switch (tx.type) {
            TransactionType.income => Icons.arrow_downward_rounded,
            TransactionType.expense => Icons.arrow_upward_rounded,
            TransactionType.transfer => Icons.swap_horiz_rounded,
          };

    final txCurrency = _txCurrency(tx, accountMap, fallbackCurrency);
    final sign = switch (tx.type) {
      TransactionType.income => '+',
      TransactionType.expense => '-',
      TransactionType.transfer => '',
    };
    final amountText = '$sign${txCurrency.format(tx.amount)}';
    final amountColor = switch (tx.type) {
      TransactionType.income => Colors.green.shade700,
      TransactionType.expense => Colors.red.shade600,
      TransactionType.transfer => context.colorScheme.outline,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? context.colorScheme.surfaceContainerHigh : Colors.white,
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
                    showTime ? secondaryText : '$secondaryText · ${_formatTime(tx.date, t)}',
                    style: const TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 12,
                      color: Color(0xFF9EAEA2),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Amount + optional time column
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

// ── Calendar view ─────────────────────────────────────────────────────────────

class _CalendarView extends ConsumerWidget {
  const _CalendarView({
    required this.calendarMonth,
    required this.selectedDay,
    required this.onMonthChanged,
    required this.onDaySelected,
    super.key,
  });

  final DateTime calendarMonth;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final txsByDate = ref.watch(transactionsByDateProvider);
    final categoryMap = ref
        .watch(categoriesProvider)
        .when(
          data: (cats) => {for (final c in cats) c.id: c},
          loading: () => <String, Category>{},
          error: (_, _) => <String, Category>{},
        );
    final accountMap = {for (final a in ref.watch(accountModelsProvider)) a.id: a};

    final selectedKey = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final selectedTxs = (txsByDate[selectedKey] ?? [])..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: _CalendarCard(
            month: calendarMonth,
            selectedDay: selectedDay,
            txsByDate: txsByDate,
            categoryMap: categoryMap,
            onPrev: () => onMonthChanged(
              DateTime(calendarMonth.year, calendarMonth.month - 1),
            ),
            onNext: () => onMonthChanged(
              DateTime(calendarMonth.year, calendarMonth.month + 1),
            ),
            onDaySelected: onDaySelected,
          ),
        ),
        Expanded(
          child: _DayTransactionList(
            transactions: selectedTxs,
            accountMap: accountMap,
            fallbackCurrency: currency,
            categoryMap: categoryMap,
            selectedDay: selectedDay,
            onTransactionTap: (tx) => context.push(AppRoutes.transactionEdit(tx.id)),
            onAddTransaction: () => context.push(AppRoutes.addTransactionOnDate(selectedDay)),
          ),
        ),
      ],
    );
  }
}

// White card wrapping the calendar header + grid.
class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.month,
    required this.selectedDay,
    required this.txsByDate,
    required this.categoryMap,
    required this.onPrev,
    required this.onNext,
    required this.onDaySelected,
  });

  final DateTime month;
  final DateTime selectedDay;
  final Map<DateTime, List<Transaction>> txsByDate;
  final Map<String, Category> categoryMap;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: isDark ? context.colorScheme.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: label + title on left, nav arrows on right
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.home.financial_schedule,
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
                      DateFormat('MMMM yyyy').format(month),
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.scrim,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _NavArrow(onTap: onPrev, icon: Icons.chevron_left_rounded),
                  const SizedBox(width: 8),
                  _NavArrow(onTap: onNext, icon: Icons.chevron_right_rounded),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _CalendarGrid(
            month: month,
            selectedDay: selectedDay,
            txsByDate: txsByDate,
            categoryMap: categoryMap,
            onDaySelected: onDaySelected,
          ),
        ],
      ),
    );
  }
}

// Small square arrow button used for month navigation.
class _NavArrow extends StatelessWidget {
  const _NavArrow({required this.onTap, required this.icon});

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isDark ? context.colorScheme.surfaceContainerHighest : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: context.colorScheme.scrim),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.selectedDay,
    required this.txsByDate,
    required this.categoryMap,
    required this.onDaySelected,
  });

  final DateTime month;
  final DateTime selectedDay;
  final Map<DateTime, List<Transaction>> txsByDate;
  final Map<String, Category> categoryMap;
  final ValueChanged<DateTime> onDaySelected;

  // Sunday-first: S M T W T F S
  static const _weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  // Returns cells with (date, isCurrentMonth).
  // Leading cells are the trailing days of the previous month;
  // trailing cells are the leading days of the next month.
  List<({DateTime date, bool isCurrentMonth})> _buildCells() {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    // weekday: Mon=1 … Sun=7. For Sunday-first (Sun=col0): (weekday % 7)
    final leadingCount = firstDay.weekday % 7;

    final prevMonthLastDay = DateTime(month.year, month.month, 0);

    final cells = <({DateTime date, bool isCurrentMonth})>[];

    // Trailing days of previous month
    for (int i = leadingCount - 1; i >= 0; i--) {
      cells.add((
        date: DateTime(
          prevMonthLastDay.year,
          prevMonthLastDay.month,
          prevMonthLastDay.day - i,
        ),
        isCurrentMonth: false,
      ));
    }

    // Days of current month
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add((
        date: DateTime(month.year, month.month, d),
        isCurrentMonth: true,
      ));
    }

    // Leading days of next month to fill last row
    final trailingCount = (7 - cells.length % 7) % 7;
    for (int d = 1; d <= trailingCount; d++) {
      cells.add((
        date: DateTime(month.year, month.month + 1, d),
        isCurrentMonth: false,
      ));
    }

    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final cells = _buildCells();
    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day);
    final selectedKey = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    final rowCount = (cells.length / 7).ceil();

    return Column(
      children: [
        // Weekday header row
        Row(
          children: List.generate(
            7,
            (i) => Expanded(
              child: Center(
                child: Text(
                  _weekdayLabels[i],
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: (i == 0 || i == 6) ? context.colorScheme.outline : context.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Day rows
        ...List.generate(rowCount, (row) {
          return Row(
            children: List.generate(7, (col) {
              final idx = row * 7 + col;
              if (idx >= cells.length) {
                return const Expanded(child: SizedBox(height: 48));
              }
              final cell = cells[idx];
              final dayKey = DateTime(
                cell.date.year,
                cell.date.month,
                cell.date.day,
              );
              final isSelected = cell.isCurrentMonth && dayKey == selectedKey;
              final isToday = dayKey == todayKey;
              final txs = cell.isCurrentMonth ? (txsByDate[dayKey] ?? []) : <Transaction>[];

              // Up to 3 dots, each coloured by the transaction's category (or type)
              final dots = txs.take(3).map((tx) {
                final cat = tx.categoryId != null ? categoryMap[tx.categoryId] : null;
                return cat != null
                    ? Color(cat.color)
                    : switch (tx.type) {
                        TransactionType.income => Colors.green.shade500,
                        TransactionType.expense => Colors.red.shade400,
                        TransactionType.transfer => Colors.grey.shade400,
                      };
              }).toList();

              return Expanded(
                child: GestureDetector(
                  onTap: cell.isCurrentMonth ? () => onDaySelected(cell.date) : null,
                  child: SizedBox(
                    height: 52,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: isSelected
                              ? BoxDecoration(
                                  color: context.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                )
                              : isToday
                              ? BoxDecoration(
                                  border: Border.all(
                                    color: context.colorScheme.primary,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                )
                              : null,
                          child: Center(
                            child: Text(
                              '${cell.date.day}',
                              style: TextStyle(
                                fontFamily: 'Epilogue',
                                fontSize: 13,
                                fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : cell.isCurrentMonth
                                    ? context.colorScheme.scrim
                                    : context.colorScheme.outline.withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                        ),
                        // Dot row — always reserves space so rows stay aligned
                        SizedBox(
                          height: 8,
                          child: dots.isNotEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: dots
                                      .map(
                                        (c) => Container(
                                          width: 4,
                                          height: 4,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 1,
                                          ),
                                          decoration: BoxDecoration(
                                            color: c,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}

// ── Day transaction list (below calendar) ─────────────────────────────────────

class _TotalBadge extends StatelessWidget {
  const _TotalBadge({required this.total, required this.currency});

  final double total;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final isPositive = total >= 0;
    final textColor = isPositive ? Colors.green.shade700 : Colors.red.shade600;
    final bgColor = isPositive ? Colors.green.shade50 : Colors.red.shade50;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${isPositive ? '+' : ''}${currency.format(total)}',
        style: TextStyle(
          fontFamily: 'Epilogue',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _DayTransactionList extends StatelessWidget {
  const _DayTransactionList({
    required this.transactions,
    required this.accountMap,
    required this.fallbackCurrency,
    required this.categoryMap,
    required this.selectedDay,
    required this.onTransactionTap,
    required this.onAddTransaction,
  });

  final List<Transaction> transactions;
  final Map<String, AccountModel> accountMap;
  final Currency fallbackCurrency;
  final Map<String, Category> categoryMap;
  final DateTime selectedDay;
  final ValueChanged<Transaction> onTransactionTap;
  final VoidCallback onAddTransaction;

  double get _total => transactions.fold(0.0, (sum, tx) {
    return sum +
        switch (tx.type) {
          TransactionType.income => tx.amount,
          TransactionType.expense => -tx.amount,
          TransactionType.transfer => 0.0,
        };
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final dateLabel = DateFormat('MMM d').format(selectedDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with total badge
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.home.transactions_for.replaceAll('{date}', dateLabel),
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.scrim,
                ),
              ),
              if (transactions.isNotEmpty) _TotalBadge(total: _total, currency: fallbackCurrency),
            ],
          ),
        ),
        if (transactions.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    t.home.no_transactions_day,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 14,
                      color: context.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: onAddTransaction,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(
                      t.home.add_transaction_on_day,
                      style: const TextStyle(fontFamily: 'Epilogue'),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              itemCount: transactions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) => _TransactionTile(
                tx: transactions[i],
                accountMap: accountMap,
                fallbackCurrency: fallbackCurrency,
                categoryMap: categoryMap,
                showTime: true,
                onTap: () => onTransactionTap(transactions[i]),
              ),
            ),
          ),
      ],
    );
  }
}
