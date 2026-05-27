import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final accountsAsync = ref.watch(accountsProvider);
    final models = ref.watch(accountModelsProvider);
    final totalNetWorth = ref.watch(totalNetWorthProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: ExpenseLabAppBar(
        title: t.accounts.title,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colorScheme.primary,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/accounts/create'),
            icon: Icon(Icons.add_rounded, color: context.colorScheme.primary),
          ),
        ],
      ),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (_) {
          final cashAccounts = models.where((a) => a.type == AccountType.cash).toList();
          final bankAccounts = models.where((a) => a.type == AccountType.bankAccount).toList();
          final creditCards = models.where((a) => a.type == AccountType.creditCard).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              _NetWorthCard(totalNetWorth: totalNetWorth, currency: currency),
              const SizedBox(height: 28),
              if (cashAccounts.isNotEmpty) ...[
                _SectionHeader(title: t.accounts.cash_accounts),
                const SizedBox(height: 12),
                ...cashAccounts.map(
                  (model) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AccountCard(model: model),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (bankAccounts.isNotEmpty) ...[
                _SectionHeader(title: t.accounts.bank_accounts),
                const SizedBox(height: 12),
                ...bankAccounts.map(
                  (model) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AccountCard(model: model),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (creditCards.isNotEmpty) ...[
                _SectionHeader(title: t.accounts.credit_cards),
                const SizedBox(height: 12),
                ...creditCards.map(
                  (model) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AccountCard(model: model),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _NetWorthCard extends StatelessWidget {
  const _NetWorthCard({
    required this.totalNetWorth,
    required this.currency,
    this.monthlyChangePct, // ignore: unused_element_parameter
  });

  final double totalNetWorth;
  final Currency currency;
  final double? monthlyChangePct;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF2D6831),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.accounts.total_net_worth,
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currency.format(totalNetWorth),
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          if (monthlyChangePct != null) ...[
            const SizedBox(height: 12),
            _MonthlyChangeBadge(
              percentage: monthlyChangePct!,
              label: t.accounts.monthly_change.replaceAll(
                '{percentage}',
                '${monthlyChangePct! >= 0 ? '+' : ''}${(monthlyChangePct! * 100).toStringAsFixed(1)}%',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthlyChangeBadge extends StatelessWidget {
  const _MonthlyChangeBadge({required this.percentage, required this.label});

  final double percentage;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            percentage >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleMedium!.copyWith(color: context.colorScheme.scrim),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.model});

  final AccountModel model;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final formatted = formatCurrency(model.balance, model.currencyCode);
    final iconData = iconFromName(model.icon);

    return GestureDetector(
      onTap: () => context.push('/accounts/${model.id}/edit'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    iconData,
                    color: context.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: context.colorScheme.scrim,
                        ),
                      ),
                      Text(
                        t.currencies[model.currencyCode.toUpperCase()]!,
                        style: const TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF9EAEA2),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              formatted,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: context.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
