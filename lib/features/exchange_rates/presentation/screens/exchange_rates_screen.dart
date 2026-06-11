import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/exchange_rates/domain/models/exchange_rate_model.dart';
import 'package:expenselab/features/exchange_rates/providers/exchange_rates_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExchangeRatesScreen extends ConsumerWidget {
  const ExchangeRatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rates = ref.watch(exchangeRateModelsProvider);
    final isLoading = ref.watch(exchangeRatesProvider).isLoading;

    // Group by currency pair.
    final groups = <String, List<ExchangeRateModel>>{};
    for (final r in rates) {
      final key = '${r.fromCurrencyCode}→${r.toCurrencyCode}';
      groups.putIfAbsent(key, () => []).add(r);
    }

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
      appBar: ExpenseLabAppBar(
        title: 'Exchange Rates',
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.colorScheme.primary),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'exchange_rates_fab',
        onPressed: () => context.push(AppRoutes.exchangeRatesCreate),
        backgroundColor: context.colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : rates.isEmpty
                ? _EmptyState(isDark: isDark)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    children: [
                      for (final entry in groups.entries) ...[
                        _PairHeader(pair: entry.key, isDark: isDark),
                        const SizedBox(height: 8),
                        ...entry.value.map(
                          (r) => _RateTile(
                            rate: r,
                            isDark: isDark,
                            onTap: () => context
                                .push(AppRoutes.exchangeRateEdit(r.id)),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
      ),
    );
  }
}

class _PairHeader extends StatelessWidget {
  const _PairHeader({required this.pair, required this.isDark});

  final String pair;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      pair,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w700,
        fontSize: 13,
        letterSpacing: 0.8,
        color: context.colorScheme.primary,
      ),
    );
  }
}

class _RateTile extends StatelessWidget {
  const _RateTile({
    required this.rate,
    required this.isDark,
    required this.onTap,
  });

  final ExchangeRateModel rate;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('MMM d, yyyy').format(rate.date.toLocal());
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2420) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1 ${rate.fromCurrencyCode} = ${rate.rate} ${rate.toCurrencyCode}',
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF0F1E36),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateLabel,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 12,
                      color:
                          isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark ? Colors.white24 : const Color(0xFFBDBDBD),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark});

  final bool isDark;

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
                Icons.currency_exchange_rounded,
                size: 72,
                color: context.colorScheme.primary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 20),
              Text(
                'No exchange rates yet',
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
                'Add rates to convert balances and budgets across currencies.',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  color:
                      isDark ? Colors.white38 : const Color(0xFF9EAEA2),
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
