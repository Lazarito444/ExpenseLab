import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  String _formatAccountBalance(String? currencyCode, double balance) {
    try {
      final currency = kSupportedCurrencies.firstWhere((c) => c.code == (currencyCode ?? 'USD'));
      return currency.format(balance);
    } catch (_) {
      return NumberFormat.simpleCurrency(name: currencyCode ?? 'USD').format(balance);
    }
  }

  String _getLocalizedAccountType(BuildContext context, AccountType? type) {
    final t = context.t;
    switch (type ?? AccountType.bankAccount) {
      case AccountType.cash:
        return t.accounts.create.type_cash;
      case AccountType.bankAccount:
        return t.accounts.create.type_savings;
      case AccountType.creditCard:
        return t.accounts.create.type_credit_card;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accountsAsync = ref.watch(accountsProvider);
    final netWorth = ref.watch(totalNetWorthProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            // Styled business Suit male cartoon profile avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF81C784),
                    Color(0xFF2E7D32),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.black.withValues(alpha: 0.08),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              t.app.name,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/categories'),
            icon: Icon(
              Icons.category_rounded,
              color: context.colorScheme.primary,
              size: 26,
            ),
            tooltip: t.categories.title,
          ),
          IconButton(
            onPressed: () => context.push('/accounts/create'),
            icon: Icon(
              Icons.add,
              color: context.colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: accountsAsync.when(
        data: (accounts) {
          final cashAccounts = accounts.where((a) => a.type == AccountType.cash).toList();
          final bankAccounts = accounts.where((a) => a.type == AccountType.bankAccount).toList();
          final creditCards = accounts.where((a) => a.type == AccountType.creditCard).toList();
          final defaultCurrency = accounts.isNotEmpty ? (accounts.first.currencyCode) : 'USD';

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(accountsProvider);
            },
            color: context.colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Header Section
                  Text(
                    t.accounts.title,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                      color: isDark ? Colors.white : const Color(0xFF0F1E36),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.accounts.subtitle,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: isDark ? Colors.white60 : const Color(0xFF5D6B60),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Premium Net Worth Card
                  _buildNetWorthCard(context, defaultCurrency, netWorth),
                  const SizedBox(height: 32),

                  // If absolutely no accounts exist, show beautiful empty state
                  if (accounts.isEmpty) ...[
                    _buildEmptyStateCard(
                      context,
                      t.accounts.title,
                      t.accounts.subtitle,
                    ),
                  ] else ...[
                    // Cash Accounts Section
                    if (cashAccounts.isNotEmpty) ...[
                      Text(
                        t.accounts.cash_accounts,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: isDark ? Colors.white : const Color(0xFF0F1E36),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cashAccounts.length,
                        itemBuilder: (context, index) {
                          final account = cashAccounts[index];
                          final balance = ref.watch(accountBalanceProvider(account.id));
                          return _buildAccountItem(context, ref, account, balance);
                        },
                      ),
                    ],

                    // Bank Accounts Section
                    if (bankAccounts.isNotEmpty) ...[
                      Text(
                        t.accounts.bank_accounts,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: isDark ? Colors.white : const Color(0xFF0F1E36),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bankAccounts.length,
                        itemBuilder: (context, index) {
                          final account = bankAccounts[index];
                          final balance = ref.watch(accountBalanceProvider(account.id));
                          return _buildAccountItem(context, ref, account, balance);
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Credit Cards Section
                    if (creditCards.isNotEmpty) ...[
                      Text(
                        t.accounts.credit_cards,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: isDark ? Colors.white : const Color(0xFF0F1E36),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: creditCards.length,
                        itemBuilder: (context, index) {
                          final account = creditCards[index];
                          final balance = ref.watch(accountBalanceProvider(account.id));
                          return _buildAccountItem(context, ref, account, balance);
                        },
                      ),
                    ],
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: context.colorScheme.primary,
          ),
        ),
        error: (err, stack) {
          debugPrint("Accounts Screen Error: $err\n$stack");
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 48),
                const SizedBox(height: 16),
                Text(
                  err.toString(),
                  style: const TextStyle(fontFamily: 'Epilogue', fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNetWorthCard(BuildContext context, String currencyCode, double amount) {
    final t = context.t;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary,
            const Color(0xFF4C8D5B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.accounts.total_net_worth,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatAccountBalance(currencyCode, amount),
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.bold,
              fontSize: 34,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Capsule trend badge matching the design perfectly
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  "+2.4% ${t.accounts.this_month}",
                  style: const TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context, WidgetRef ref, Account account, double balance) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2420) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            context.push('/accounts/details/${account.id}');
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top part of the card
                Row(
                  children: [
                    // Stylized Icon Container matching visual design
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(
                          iconFromName(account.icon),
                          color: context.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.name,
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isDark ? Colors.white : const Color(0xFF1C221E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getLocalizedAccountType(context, account.type),
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: isDark ? Colors.white60 : const Color(0xFF5D6B60),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Middle part of the card - balance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatAccountBalance(account.currencyCode, balance),
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context, String title, String subtitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2420) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: context.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 14,
              color: isDark ? Colors.white60 : const Color(0xFF5D6B60),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/accounts/create'),
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              "Add Account",
              style: TextStyle(fontFamily: 'Epilogue', fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
