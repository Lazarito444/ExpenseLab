import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
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

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  List<AccountModel> _cashAccounts = [];
  List<AccountModel> _bankAccounts = [];
  List<AccountModel> _creditCards = [];

  static bool _idOrderMatches(List<AccountModel> a, List<AccountModel> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  void _syncModels(List<AccountModel> models) {
    final cash = models.where((a) => a.type == AccountType.cash).toList();
    final bank = models.where((a) => a.type == AccountType.bankAccount).toList();
    final credit = models.where((a) => a.type == AccountType.creditCard).toList();

    if (!_idOrderMatches(_cashAccounts, cash) ||
        !_idOrderMatches(_bankAccounts, bank) ||
        !_idOrderMatches(_creditCards, credit)) {
      setState(() {
        _cashAccounts = cash;
        _bankAccounts = bank;
        _creditCards = credit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accountsAsync = ref.watch(accountsProvider);
    final models = ref.watch(accountModelsProvider);
    final totalNetWorth = ref.watch(totalNetWorthProvider);
    final currency = ref.watch(currencyProvider);

    ref.listen(accountModelsProvider, (prev, next) {
      _syncModels(next);
    });

    if (_cashAccounts.isEmpty && _bankAccounts.isEmpty && _creditCards.isEmpty) {
      _syncModels(models);
    }

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
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
            onPressed: () => context.push(AppRoutes.accountsCreate),
            icon: Icon(Icons.add_rounded, color: context.colorScheme.primary),
          ),
        ],
      ),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (_) {
          if (_cashAccounts.isEmpty && _bankAccounts.isEmpty && _creditCards.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  t.accounts.empty_state,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 15,
                    color: context.colorScheme.outline,
                  ),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              _NetWorthCard(totalNetWorth: totalNetWorth, currency: currency),
              const SizedBox(height: 28),
              if (_cashAccounts.isNotEmpty) ...[
                _SectionHeader(title: t.accounts.cash_accounts),
                const SizedBox(height: 12),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorderItem: (oldIndex, newIndex) {
                    final item = _cashAccounts.removeAt(oldIndex);
                    _cashAccounts.insert(newIndex, item);
                    setState(() {});
                    ref.read(accountsRepositoryProvider).reorderAccount(
                      item.id, oldIndex, newIndex,
                    );
                  },
                  children: [
                    for (var i = 0; i < _cashAccounts.length; i++)
                      Padding(
                        key: ValueKey(_cashAccounts[i].id),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _AccountCard(model: _cashAccounts[i], index: i),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              if (_bankAccounts.isNotEmpty) ...[
                _SectionHeader(title: t.accounts.bank_accounts),
                const SizedBox(height: 12),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorderItem: (oldIndex, newIndex) {
                    final item = _bankAccounts.removeAt(oldIndex);
                    _bankAccounts.insert(newIndex, item);
                    setState(() {});
                    ref.read(accountsRepositoryProvider).reorderAccount(
                      item.id, oldIndex, newIndex,
                    );
                  },
                  children: [
                    for (var i = 0; i < _bankAccounts.length; i++)
                      Padding(
                        key: ValueKey(_bankAccounts[i].id),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _AccountCard(model: _bankAccounts[i], index: i),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              if (_creditCards.isNotEmpty) ...[
                _SectionHeader(title: t.accounts.credit_cards),
                const SizedBox(height: 12),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorderItem: (oldIndex, newIndex) {
                    final item = _creditCards.removeAt(oldIndex);
                    _creditCards.insert(newIndex, item);
                    setState(() {});
                    ref.read(accountsRepositoryProvider).reorderAccount(
                      item.id, oldIndex, newIndex,
                    );
                  },
                  children: [
                    for (var i = 0; i < _creditCards.length; i++)
                      Padding(
                        key: ValueKey(_creditCards[i].id),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CreditCardCard(model: _creditCards[i], index: i),
                      ),
                  ],
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
        color: totalNetWorth < 0
            ? context.appColors.balanceCardNegativeBg
            : context.appColors.balanceCardPositiveBg,
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
  const _AccountCard({required this.model, required this.index});

  final AccountModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final appColors = context.appColors;
    final formatted = formatCurrency(model.balance, model.currencyCode);
    final iconData = iconFromName(model.icon);

    return GestureDetector(
      onTap: () {}, // reserved — will navigate to account details
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appColors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: appColors.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: appColors.secondaryLabel),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formatted,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: context.colorScheme.outline,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.drag_indicator,
                          color: context.colorScheme.outline,
                          size: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.accountEdit(model.id)),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditCardCard extends StatelessWidget {
  const _CreditCardCard({required this.model, required this.index});

  final AccountModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final appColors = context.appColors;
    final iconData = iconFromName(model.icon);
    final outstanding = model.displayBalance;
    final util = model.utilization;
    final avail = model.availableCredit;
    final minPay = model.minimumPayment;
    final nextDue = model.nextPaymentDate;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.creditCardPay(model.id)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appColors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconData, color: context.colorScheme.primary, size: 22),
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
                      if (model.apr != null)
                        Text(
                          'APR ${model.apr!.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: appColors.secondaryLabel,
                          ),
                        ),
                    ],
                  ),
                ),
                // Pay button
                GestureDetector(
                  onTap: () => context.push(AppRoutes.creditCardPay(model.id)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t.accounts.credit_card_card.pay,
                      style: const TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Outstanding balance ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.accounts.credit_card_card.outstanding,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 12,
                    color: appColors.secondaryLabel,
                  ),
                ),
                Text(
                  formatCurrency(outstanding, model.currencyCode),
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: outstanding > 0
                        ? context.colorScheme.error
                        : context.colorScheme.outline,
                  ),
                ),
              ],
            ),

            // ── Utilization bar ──
            if (util != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: util,
                  minHeight: 6,
                  backgroundColor: appColors.inputFill,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    util < 0.3
                        ? const Color(0xFF34C759)
                        : util < 0.7
                            ? const Color(0xFFFF9500)
                            : const Color(0xFFFF3B30),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(util * 100).toStringAsFixed(1)}% ${t.accounts.credit_card_card.utilization}',
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 11,
                      color: appColors.secondaryLabel,
                    ),
                  ),
                  if (avail != null)
                    Text(
                      '${formatCurrency(avail, model.currencyCode)} ${t.accounts.credit_card_card.available}',
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 11,
                        color: appColors.secondaryLabel,
                      ),
                    ),
                ],
              ),
            ],

            // ── Due date & minimum payment row ──
            if (nextDue != null || minPay != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (nextDue != null) ...[
                    Icon(Icons.calendar_today_rounded, size: 14, color: appColors.secondaryLabel),
                    const SizedBox(width: 4),
                    Text(
                      '${t.accounts.credit_card_card.due} ${_formatDate(nextDue)}',
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 12,
                        fontWeight: _isUrgent(nextDue) ? FontWeight.w600 : FontWeight.w400,
                        color: _isUrgent(nextDue)
                            ? context.colorScheme.error
                            : appColors.secondaryLabel,
                      ),
                    ),
                  ],
                  if (nextDue != null && minPay != null) ...[
                    const SizedBox(width: 16),
                  ],
                  if (minPay != null) ...[
                    Icon(Icons.payments_rounded, size: 14, color: appColors.secondaryLabel),
                    const SizedBox(width: 4),
                    Text(
                      '${t.accounts.credit_card_card.minimum_payment} ${formatCurrency(minPay, model.currencyCode)}',
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 12,
                        color: appColors.secondaryLabel,
                      ),
                    ),
                  ],
                ],
              ),
            ],

            // ── Rewards line ──
            if (model.rewardType != null && model.rewardRate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.card_giftcard_rounded, size: 14, color: appColors.secondaryLabel),
                  const SizedBox(width: 4),
                  Text(
                    '${t.accounts.credit_card_card.rewards_earned}: ${_rewardLabel(model)}',
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 12,
                      color: appColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // ── Bottom row: drag handle + edit ──
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.drag_indicator, color: context.colorScheme.outline, size: 20),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.accountEdit(model.id)),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.edit_outlined, size: 16, color: context.colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isUrgent(DateTime date) {
    final diff = date.difference(DateTime.now()).inDays;
    return diff <= 7 && diff >= 0;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _rewardLabel(AccountModel model) {
    final outstanding = model.displayBalance;
    if (outstanding <= 0 || model.rewardRate == null) return '--';
    final earned = outstanding * model.rewardRate!;
    switch (model.rewardType) {
      case 'cashback':
        return formatCurrency(earned, model.currencyCode);
      case 'points':
        return '${earned.round().toString()} pts';
      case 'miles':
        return '${earned.round().toString()} mi';
      default:
        return earned.toStringAsFixed(2);
    }
  }
}
