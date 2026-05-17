import 'package:drift/drift.dart' show Value;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';
import 'package:expenselab/features/accounts/presentation/screens/currency_selection_screen.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController(text: '0.00');

  // Form values
  String _selectedIconName = 'wallet';
  AccountType _selectedType = AccountType.cash;
  String _selectedCurrency = 'USD';

  // State for loading
  bool _isLoading = false;

  // Curated list of quick selectable icons
  final List<String> _quickIcons = ['wallet', 'savings', 'credit_card', 'payments'];

  // List of extra icons for custom selector
  final List<String> _extraIcons = [
    'account_balance',
    'account_box',
    'account_circle',
    'card_giftcard',
    'card_travel',
    'currency_exchange',
    'home',
    'shopping_bag',
    'shopping_cart',
    'show_chart',
    'trending_up',
    'work',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  // Get currency symbol
  String _getCurrencySymbol(String currencyCode) {
    try {
      return kSupportedCurrencies.firstWhere((c) => c.code == currencyCode).symbol;
    } catch (_) {
      return '\$';
    }
  }

  // Show premium bottom sheet for custom icon selection
  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2420) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.t.create_account.icon,
                    style: const TextStyle(
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: _extraIcons.length,
                itemBuilder: (context, index) {
                  final iconName = _extraIcons[index];
                  final isSelected = _selectedIconName == iconName;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIconName = iconName;
                      });
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? context.colorScheme.primary : (isDark ? const Color(0xFF171B18) : const Color(0xFFF0F4F1)),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? context.colorScheme.primary : (isDark ? Colors.white12 : const Color(0xFFDCE3DF)),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        iconFromName(iconName),
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : context.colorScheme.primary),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // Handle save
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final double balance = double.tryParse(_balanceController.text.trim()) ?? 0.0;

      // 1. Create the account in database
      final accountId = await ref
          .read(accountsRepositoryProvider)
          .create(
            AccountsCompanion(
              name: Value(name),
              type: Value(_selectedType),
              currencyCode: Value(_selectedCurrency),
              icon: Value(_selectedIconName),
            ),
          );

      // 2. If initial balance > 0, insert an initial income transaction
      if (balance > 0) {
        await ref
            .read(transactionsRepositoryProvider)
            .create(
              TransactionsCompanion(
                type: const Value(TransactionType.income),
                amount: Value(balance),
                date: Value(DateTime.now()),
                note: const Value('Initial Balance'),
                accountId: Value(accountId),
              ),
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.create_account.success),
            backgroundColor: context.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: context.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final labelStyle = TextStyle(
      fontFamily: 'Epilogue',
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: isDark ? Colors.white70 : const Color(0xFF333D35),
    );

    final inputTextStyle = TextStyle(
      fontFamily: 'Epilogue',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white : const Color(0xFF1C221E),
    );

    final balanceTextStyle = TextStyle(
      fontFamily: 'Epilogue',
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white : const Color(0xFF5D6B60),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: context.colorScheme.primary,
            size: 28,
          ),
        ),
        title: Text(
          t.create_account.title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2420) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                      ],
                      border: Border.all(
                        color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Account Icon
                        Text(t.create_account.icon, style: labelStyle),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ..._quickIcons.map((iconName) {
                              final isSelected = _selectedIconName == iconName;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIconName = iconName;
                                  });
                                },
                                child: Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: isSelected ? context.colorScheme.primary : (isDark ? const Color(0xFF171B18) : Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? context.colorScheme.primary : (isDark ? Colors.white12 : const Color(0xFFDCE3DF)),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Icon(
                                    iconFromName(iconName),
                                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : context.colorScheme.primary),
                                  ),
                                ),
                              );
                            }),
                            // Custom More Button
                            GestureDetector(
                              onTap: _showIconPicker,
                              child: Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: !_quickIcons.contains(_selectedIconName) ? context.colorScheme.primary : (isDark ? const Color(0xFF171B18) : Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: !_quickIcons.contains(_selectedIconName) ? context.colorScheme.primary : (isDark ? Colors.white12 : const Color(0xFFDCE3DF)),
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  !_quickIcons.contains(_selectedIconName) ? iconFromName(_selectedIconName) : Icons.more_horiz,
                                  color: !_quickIcons.contains(_selectedIconName) ? Colors.white : (isDark ? Colors.white70 : context.colorScheme.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Account Name
                        Text(t.create_account.name, style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          style: inputTextStyle,
                          decoration: InputDecoration(
                            hintText: t.create_account.name_hint,
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.normal,
                            ),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF171B18) : const Color(0xFFFAFAFA),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: context.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: context.colorScheme.error,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return t.create_account.name_required;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Account Type
                        Text(t.create_account.type, style: labelStyle),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<AccountType>(
                          initialValue: _selectedType,
                          style: inputTextStyle,
                          dropdownColor: isDark ? const Color(0xFF1E2420) : Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDark ? const Color(0xFF171B18) : const Color(0xFFFAFAFA),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: context.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: AccountType.bankAccount,
                              child: Text(t.create_account.type_savings),
                            ),
                            DropdownMenuItem(
                              value: AccountType.cash,
                              child: Text(t.create_account.type_cash),
                            ),
                            DropdownMenuItem(
                              value: AccountType.creditCard,
                              child: Text(t.create_account.type_credit_card),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedType = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        // Currency
                        Text(t.create_account.currency, style: labelStyle),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final selected = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CurrencySelectionScreen(
                                  currentSelectedCode: _selectedCurrency,
                                ),
                              ),
                            );
                            if (selected != null && mounted) {
                              setState(() {
                                _selectedCurrency = selected;
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF171B18) : const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Show code
                                Text(
                                  _selectedCurrency,
                                  style: inputTextStyle.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${t.currencies[_selectedCurrency] ?? kSupportedCurrencies.firstWhere((c) => c.code == _selectedCurrency).name})',
                                  style: inputTextStyle.copyWith(
                                    color: isDark ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF5D6B60),
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Initial Balance
                        Text(t.create_account.initial_balance, style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _balanceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: balanceTextStyle,
                          decoration: InputDecoration(
                            prefixText: '${_getCurrencySymbol(_selectedCurrency)} ',
                            prefixStyle: balanceTextStyle,
                            filled: true,
                            fillColor: isDark ? const Color(0xFF171B18) : const Color(0xFFFAFAFA),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: context.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: context.colorScheme.error,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              final parsed = double.tryParse(value.trim());
                              if (parsed == null) {
                                return t.create_account.balance_invalid;
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Pro Tip Card
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF19251C) : const Color(0xFFF1F6F2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2C4331) : const Color(0xFFE2EAE3),
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: context.colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Epilogue',
                                      fontSize: 14,
                                      color: isDark ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF4A554D),
                                      height: 1.4,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Pro Tip: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: context.colorScheme.primary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: t.create_account.pro_tip.replaceFirst('Pro Tip: ', ''),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitForm,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.add_card, color: Colors.white, size: 22),
                  label: Text(
                    t.create_account.create_button,
                    style: const TextStyle(
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.primary,
                    elevation: 4,
                    shadowColor: context.colorScheme.primary.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
