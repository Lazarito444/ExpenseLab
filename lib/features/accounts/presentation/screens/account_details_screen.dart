import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AccountDetailsScreen extends ConsumerWidget {
  final String accountId;

  const AccountDetailsScreen({
    required this.accountId,
    super.key,
  });

  String _formatCurrency(String? currencyCode, double balance) {
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
        return t.create_account.type_cash;
      case AccountType.bankAccount:
        return t.create_account.type_savings;
      case AccountType.creditCard:
        return t.create_account.type_credit_card;
    }
  }

  // Calculate monthly stats
  Map<String, dynamic> _calculateMonthlyStats(List<Transaction> transactions, double currentBalance) {
    final now = DateTime.now();
    var thisMonthIncome = 0.0;
    var thisMonthExpense = 0.0;

    for (final tx in transactions) {
      if (tx.date.year == now.year && tx.date.month == now.month) {
        switch (tx.type) {
          case TransactionType.income:
            thisMonthIncome += tx.amount;
            break;
          case TransactionType.expense:
            thisMonthExpense += tx.amount;
            break;
          case TransactionType.transfer:
            // If transfer from this account, it is an expense. If to this account, it is an income.
            if (tx.accountId == accountId) {
              thisMonthExpense += tx.amount;
            } else if (tx.toAccountId == accountId) {
              thisMonthIncome += tx.amount;
            }
            break;
        }
      }
    }

    final netChange = thisMonthIncome - thisMonthExpense;
    final startingBalance = currentBalance - netChange;
    var percentageChange = 0.0;

    if (startingBalance > 0.0) {
      percentageChange = (netChange / startingBalance) * 100;
    } else if (startingBalance == 0.0 && netChange > 0.0) {
      percentageChange = 100.0;
    }

    return {
      'netChange': netChange,
      'percentage': percentageChange,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accountAsync = ref.watch(accountByIdProvider(accountId));
    final balance = ref.watch(accountBalanceProvider(accountId));
    final transactionsAsync = ref.watch(transactionsByAccountProvider(accountId));
    final categoriesAsync = ref.watch(categoriesProvider);

    return accountAsync.when(
      loading: () => Scaffold(
        backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(child: Text('${t.account_details.error_loading}: $err')),
      ),
      data: (account) {
        if (account == null) {
          return Scaffold(
            backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: Center(child: Text(t.account_details.error_loading)),
          );
        }

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: context.colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              t.account_details.title,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: context.colorScheme.primary,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: context.colorScheme.primary,
                ),
                color: isDark ? const Color(0xFF1E2420) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    context.push('/accounts/edit/$accountId');
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: isDark ? Colors.white70 : const Color(0xFF1C221E),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          t.account_details.edit_account,
                          style: const TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Account overview header (Type + Balance + Monthly Growth badge)
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Text(
                        _getLocalizedAccountType(context, account.type),
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? Colors.white60 : const Color(0xFF5D6B60),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(account.currencyCode, balance),
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Monthly growth / stats badge
                      transactionsAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (err, stack) => const SizedBox.shrink(),
                        data: (txs) {
                          final stats = _calculateMonthlyStats(txs, balance);
                          final double pct = stats['percentage'];
                          final double netChange = stats['netChange'];
                          final isPositive = netChange >= 0;

                          return Container(
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? context.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.08)
                                  : context.colorScheme.error.withValues(alpha: isDark ? 0.2 : 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                                  color: isPositive ? context.colorScheme.primary : context.colorScheme.error,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  t.account_details.growth_this_month.replaceAll(
                                    '{percentage}', '${isPositive ? '+' : ''}${pct.toStringAsFixed(1)}%',
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Epilogue',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isPositive ? context.colorScheme.primary : context.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // 2. Recent Transactions Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.account_details.recent_transactions,
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF1C221E),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // In the future this can clear filter or push to history page
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: context.colorScheme.primary,
                        textStyle: const TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      child: Text(t.account_details.view_all),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 3. Transactions List Container
                transactionsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                  data: (txs) {
                    if (txs.isEmpty) {
                      return _buildEmptyTransactionsCard(context);
                    }

                    // Display list inside a beautiful container matching the mockup design
                    return Container(
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
                      child: categoriesAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => const SizedBox.shrink(),
                        data: (categories) {
                          final categoriesMap = {for (final cat in categories) cat.id: cat};
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: txs.length,
                            separatorBuilder: (context, index) => Divider(
                              color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
                              height: 1,
                              thickness: 1.2,
                            ),
                            itemBuilder: (context, index) {
                              final tx = txs[index];
                              final category = tx.categoryId != null ? categoriesMap[tx.categoryId] : null;

                              // Mapped properties for styling
                              final isIncome = tx.type == TransactionType.income || (tx.type == TransactionType.transfer && tx.toAccountId == accountId);
                              final color = category != null
                                  ? Color(category.color)
                                  : (isIncome ? context.colorScheme.primary : context.colorScheme.error);
                              
                              final icon = category != null
                                  ? iconFromName(category.icon)
                                  : (isIncome ? Icons.trending_up_rounded : Icons.trending_down_rounded);

                              final title = tx.note?.isNotEmpty == true
                                  ? tx.note!
                                  : (category?.name ?? (isIncome ? t.create_account.type_cash : t.create_account.type_savings));

                              final dateStr = DateFormat.yMMMd().format(tx.date);
                              final subLabel = category?.name != null ? '$dateStr • ${category!.name}' : dateStr;

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: Row(
                                  children: [
                                    // Animated stylized icon container
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: isDark ? 0.2 : 0.08),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        icon,
                                        color: color,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    // Title & description
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontFamily: 'Epilogue',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF1C221E),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            subLabel,
                                            style: TextStyle(
                                              fontFamily: 'Epilogue',
                                              fontSize: 12,
                                              color: isDark ? Colors.white38 : const Color(0xFF5D6B60),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Amount
                                    Text(
                                      '${isIncome ? '+' : '-'}${_formatCurrency(account.currencyCode, tx.amount)}',
                                      style: TextStyle(
                                        fontFamily: 'Epilogue',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: isIncome ? context.colorScheme.primary : context.colorScheme.error,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyTransactionsCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2420) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              context.t.account_details.no_transactions,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isDark ? Colors.white60 : const Color(0xFF5D6B60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
