import 'package:drift/drift.dart' as drift;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/formatters/currency_input_formatter.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PayCreditCardScreen extends ConsumerStatefulWidget {
  const PayCreditCardScreen({required this.accountId, super.key});

  final String accountId;

  @override
  ConsumerState<PayCreditCardScreen> createState() => _PayCreditCardScreenState();
}

class _PayCreditCardScreenState extends ConsumerState<PayCreditCardScreen> {
  final _amountController = TextEditingController();
  bool _isLoading = false;
  String _selectedAmountType = 'current'; // 'minimum', 'current', 'custom'
  AccountModel? _selectedSource;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final appColors = context.appColors;
    final accountAsync = ref.watch(accountByIdProvider(widget.accountId));
    final balance = ref.watch(accountBalanceProvider(widget.accountId));
    final models = ref.watch(accountModelsProvider);

    final sourceAccounts = models.where(
      (a) => a.type != AccountType.creditCard && a.id != widget.accountId,
    ).toList();

    if (_selectedSource == null && sourceAccounts.isNotEmpty) {
      _selectedSource = sourceAccounts.first;
    }

    final appBar = ExpenseLabAppBar(
      title: t.accounts.pay_credit_card.title,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: context.colorScheme.primary,
        ),
        onPressed: () => context.pop(),
      ),
    );

    return accountAsync.when(
      loading: () => Scaffold(
        backgroundColor: context.appColors.scaffoldBackground,
        appBar: appBar,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: context.appColors.scaffoldBackground,
        appBar: appBar,
        body: Center(child: Text(e.toString())),
      ),
      data: (account) {
        if (account == null || account.type != AccountType.creditCard) {
          return Scaffold(
            backgroundColor: context.appColors.scaffoldBackground,
            appBar: appBar,
            body: Center(child: Text(t.accounts.edit.error_loading)),
          );
        }

        final model = AccountModel.fromAccount(account, balance);
        final outstanding = model.displayBalance;
        final minPay = model.minimumPayment;
        final creditLimit = model.creditLimit;

        return Scaffold(
          backgroundColor: context.appColors.scaffoldBackground,
          appBar: appBar,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Credit card summary card ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                context.colorScheme.primary,
                                context.colorScheme.primary.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.name,
                                style: const TextStyle(
                                  fontFamily: 'Epilogue',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                t.accounts.credit_card_card.outstanding,
                                style: const TextStyle(
                                  fontFamily: 'Epilogue',
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                formatCurrency(outstanding, model.currencyCode),
                                style: const TextStyle(
                                  fontFamily: 'Epilogue',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              if (creditLimit != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '${t.accounts.credit_card_card.limit}: ${formatCurrency(creditLimit, model.currencyCode)}',
                                  style: const TextStyle(
                                    fontFamily: 'Epilogue',
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                              if (model.nextPaymentDate != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${t.accounts.credit_card_card.due} ${_formatDate(model.nextPaymentDate!)}',
                                  style: const TextStyle(
                                    fontFamily: 'Epilogue',
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Amount to pay ──
                        Text(
                          t.accounts.pay_credit_card.amount_to_pay,
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Quick amount chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _AmountChip(
                              label: t.accounts.pay_credit_card.minimum,
                              amount: minPay,
                              currencyCode: model.currencyCode,
                              selected: _selectedAmountType == 'minimum',
                              onTap: () {
                                setState(() {
                                  _selectedAmountType = 'minimum';
                                  _amountController.text = minPay != null
                                      ? CurrencyInputFormatter.formatForDisplay(minPay)
                                      : '';
                                });
                              },
                            ),
                            _AmountChip(
                              label: t.accounts.pay_credit_card.current_balance,
                              amount: outstanding,
                              currencyCode: model.currencyCode,
                              selected: _selectedAmountType == 'current',
                              onTap: () {
                                setState(() {
                                  _selectedAmountType = 'current';
                                  _amountController.text = CurrencyInputFormatter.formatForDisplay(outstanding);
                                });
                              },
                            ),
                            _AmountChip(
                              label: t.accounts.pay_credit_card.custom,
                              amount: null,
                              currencyCode: model.currencyCode,
                              selected: _selectedAmountType == 'custom',
                              onTap: () {
                                setState(() {
                                  _selectedAmountType = 'custom';
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Manual amount input
                        TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [CurrencyInputFormatter()],
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 14,
                            color: appColors.primaryText,
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: TextStyle(
                              fontFamily: 'Epilogue',
                              color: appColors.secondaryLabel,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: appColors.inputFill,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: appColors.inputBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: appColors.inputBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: context.colorScheme.primary, width: 1.5),
                            ),
                          ),
                          onChanged: (_) {
                            if (_selectedAmountType != 'custom') {
                              setState(() => _selectedAmountType = 'custom');
                            }
                          },
                        ),
                        const SizedBox(height: 22),

                        // ── Source account picker ──
                        Text(
                          t.accounts.pay_credit_card.pay_from,
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (sourceAccounts.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              t.accounts.pay_credit_card.no_source_accounts,
                              style: TextStyle(
                                fontFamily: 'Epilogue',
                                fontSize: 14,
                                color: appColors.secondaryLabel,
                              ),
                            ),
                          )
                        else
                          _SourceAccountSelector(
                            accounts: sourceAccounts,
                            selected: _selectedSource,
                            onChanged: (a) => setState(() => _selectedSource = a),
                          ),
                      ],
                    ),
                  ),
                ),

                // ── Pay button ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _pay(t),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.payments_rounded, size: 20),
                      label: Text(
                        t.accounts.pay_credit_card.pay_button,
                        style: const TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.appColors.actionButtonBg,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pay(Translations t) async {
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;
    if (_selectedSource == null) return;

    setState(() => _isLoading = true);
    try {
      final txRepo = ref.read(transactionsRepositoryProvider);

      await txRepo.create(
        TransactionsCompanion(
          type: const drift.Value(TransactionType.transfer),
          amount: drift.Value(amount),
          date: drift.Value(DateTime.now()),
          accountId: drift.Value(_selectedSource!.id),
          toAccountId: drift.Value(widget.accountId),
          note: drift.Value('${t.accounts.pay_credit_card.pay_button} — ${t.accounts.credit_card_card.outstanding}'),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.accounts.pay_credit_card.success)),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

// ── Amount chip widget ──

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.label,
    required this.amount,
    required this.currencyCode,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final double? amount;
  final String currencyCode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? context.colorScheme.primary
              : context.appColors.inputFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? context.colorScheme.primary
                : context.appColors.inputBorder,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : context.appColors.primaryText,
              ),
            ),
            if (amount != null)
              Text(
                formatCurrency(amount!, currencyCode),
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 11,
                  color: selected ? Colors.white70 : context.appColors.secondaryLabel,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Source account selector ──

class _SourceAccountSelector extends StatelessWidget {
  const _SourceAccountSelector({
    required this.accounts,
    required this.selected,
    required this.onChanged,
  });

  final List<AccountModel> accounts;
  final AccountModel? selected;
  final ValueChanged<AccountModel> onChanged;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: appColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.inputBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < accounts.length; i++) ...[
            if (i > 0)
              Divider(height: 1, color: appColors.inputBorder),
            GestureDetector(
              onTap: () => onChanged(accounts[i]),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            accounts[i].name,
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 14,
                              color: appColors.primaryText,
                            ),
                          ),
                          Text(
                            formatCurrency(accounts[i].displayBalance, accounts[i].currencyCode),
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 12,
                              color: appColors.secondaryLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected?.id == accounts[i].id)
                      Icon(
                        Icons.check_circle_rounded,
                        color: context.colorScheme.primary,
                        size: 22,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
