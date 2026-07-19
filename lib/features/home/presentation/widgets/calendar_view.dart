import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/features/home/presentation/widgets/transaction_tile.dart';
import 'package:expenselab/features/home/providers/home_providers.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CalendarView extends ConsumerWidget {
  const CalendarView({
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
    final selectedTxs = (txsByDate[selectedKey] ?? [])
      ..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: CalendarCard(
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
          child: DayTransactionList(
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

class CalendarCard extends StatelessWidget {
  const CalendarCard({
    required this.month,
    required this.selectedDay,
    required this.txsByDate,
    required this.categoryMap,
    required this.onPrev,
    required this.onNext,
    required this.onDaySelected,
    super.key,
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

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: context.appColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
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
                      toBeginningOfSentenceCase(
                        DateFormat('MMMM yyyy', LocaleSettings.currentLocale.languageTag)
                            .format(month),
                      ),
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
                  NavArrow(onTap: onPrev, icon: Icons.chevron_left_rounded),
                  const SizedBox(width: 8),
                  NavArrow(onTap: onNext, icon: Icons.chevron_right_rounded),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          CalendarGrid(
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

class NavArrow extends StatelessWidget {
  const NavArrow({required this.onTap, required this.icon, super.key});

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: context.appColors.navArrowBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: context.colorScheme.scrim),
      ),
    );
  }
}

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    required this.month,
    required this.selectedDay,
    required this.txsByDate,
    required this.categoryMap,
    required this.onDaySelected,
    super.key,
  });

  final DateTime month;
  final DateTime selectedDay;
  final Map<DateTime, List<Transaction>> txsByDate;
  final Map<String, Category> categoryMap;
  final ValueChanged<DateTime> onDaySelected;

  static const _weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  List<({DateTime date, bool isCurrentMonth})> _buildCells() {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    final leadingCount = firstDay.weekday % 7;
    final prevMonthLastDay = DateTime(month.year, month.month, 0);

    final cells = <({DateTime date, bool isCurrentMonth})>[];

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

    for (int d = 1; d <= daysInMonth; d++) {
      cells.add((
        date: DateTime(month.year, month.month, d),
        isCurrentMonth: true,
      ));
    }

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
                    color: (i == 0 || i == 6)
                        ? context.colorScheme.outline
                        : context.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
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
              final txs = cell.isCurrentMonth
                  ? (txsByDate[dayKey] ?? [])
                  : <Transaction>[];

              final appColors = context.appColors;
              final dots = txs.take(3).map((tx) {
                final cat =
                    tx.categoryId != null ? categoryMap[tx.categoryId] : null;
                return cat != null
                    ? Color(cat.color)
                    : switch (tx.type) {
                        TransactionType.income => appColors.incomeColor,
                        TransactionType.expense => appColors.expenseColor,
                        TransactionType.transfer => appColors.transferColor,
                      };
              }).toList();

              return Expanded(
                child: GestureDetector(
                  onTap:
                      cell.isCurrentMonth ? () => onDaySelected(cell.date) : null,
                  behavior: HitTestBehavior.opaque,
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
                                fontWeight: isSelected || isToday
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : cell.isCurrentMonth
                                        ? context.colorScheme.scrim
                                        : context.colorScheme.outline
                                            .withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                        ),
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

class TotalBadge extends StatelessWidget {
  const TotalBadge({required this.total, required this.currency, super.key});

  final double total;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final isPositive = total >= 0;
    final appColors = context.appColors;
    final textColor = isPositive ? appColors.incomeColor : appColors.expenseColor;
    final bgColor = isPositive ? appColors.incomeBg : appColors.expenseBg;

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

class DayTransactionList extends StatelessWidget {
  const DayTransactionList({
    required this.transactions,
    required this.accountMap,
    required this.fallbackCurrency,
    required this.categoryMap,
    required this.selectedDay,
    required this.onTransactionTap,
    required this.onAddTransaction,
    super.key,
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
              if (transactions.isNotEmpty)
                TotalBadge(total: _total, currency: fallbackCurrency),
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
              itemBuilder: (context, i) => TransactionTile(
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
