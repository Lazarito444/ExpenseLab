import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/features/home/presentation/widgets/balance_card.dart';
import 'package:expenselab/features/home/presentation/widgets/calendar_view.dart';
import 'package:expenselab/features/home/presentation/widgets/monthly_summary_card.dart';
import 'package:expenselab/features/home/presentation/widgets/transaction_tile.dart';
import 'package:expenselab/features/home/presentation/widgets/upcoming_payments.dart';
import 'package:expenselab/features/home/providers/home_providers.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final isCalendarAsync = ref.watch(homeIsCalendarProvider);

    return isCalendarAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const _DashboardView(key: ValueKey('dashboard')),
      data: (isCalendarView) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: isCalendarView
            ? CalendarView(
                key: const ValueKey('calendar'),
                calendarMonth: _calendarMonth,
                selectedDay: _selectedDay,
                onMonthChanged: (m) => setState(() => _calendarMonth = m),
                onDaySelected: (d) => setState(() => _selectedDay = d),
              )
            : const _DashboardView(key: ValueKey('dashboard')),
      ),
    );
  }
}

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
    final upcomingPayments = ref.watch(upcomingCreditCardPaymentsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        BalanceCard(
          currency: currency,
          totalBalance: totalBalance,
          changePct: changePct,
        ),
        const SizedBox(height: 20),
        MonthlySummaryCard(
          currency: currency,
          income: monthlyIncome,
          expense: monthlyExpense,
          savingsRate: savingsRate,
        ),
        if (upcomingPayments.isNotEmpty) ...[
          const SizedBox(height: 24),
          UpcomingPaymentsSection(
            payments: upcomingPayments,
            currency: currency,
          ),
        ],
        const SizedBox(height: 24),
        SectionHeader(title: t.home.recent_transactions),
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
              child: TransactionTile(
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
