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

class EditAccountScreen extends ConsumerStatefulWidget {
  final String accountId;

  const EditAccountScreen({
    required this.accountId,
    super.key,
  });

  @override
  ConsumerState<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends ConsumerState<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  // Form state
  bool _isInitialized = false;
  String _selectedIconName = 'wallet';
  AccountType _selectedType = AccountType.cash;
  String _selectedCurrency = 'USD';
  String? _initialBalanceTxId;

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

  // Show bottom sheet for custom icon selection
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
                    context.t.accounts.create.icon,
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
      final double newBalance = double.tryParse(_balanceController.text.trim()) ?? 0.0;

      // 1. Update the account row in database
      await ref
          .read(accountsRepositoryProvider)
          .update(
            widget.accountId,
            AccountsCompanion(
              name: Value(name),
              type: Value(_selectedType),
              currencyCode: Value(_selectedCurrency),
              icon: Value(_selectedIconName),
            ),
          );

      // 2. Handle Initial Balance transaction updates
      if (_initialBalanceTxId != null) {
        if (newBalance > 0.0) {
          // Update existing transaction
          await ref
              .read(transactionsRepositoryProvider)
              .update(
                _initialBalanceTxId!,
                TransactionsCompanion(
                  amount: Value(newBalance),
                ),
              );
        } else {
          // Delete existing transaction (user cleared the initial balance)
          await ref.read(transactionsRepositoryProvider).delete(_initialBalanceTxId!);
        }
      } else {
        if (newBalance > 0.0) {
          // Insert a brand new initial balance transaction
          await ref
              .read(transactionsRepositoryProvider)
              .create(
                TransactionsCompanion(
                  type: const Value(TransactionType.income),
                  amount: Value(newBalance),
                  date: Value(DateTime.now()),
                  note: const Value('Initial Balance'),
                  accountId: Value(widget.accountId),
                ),
              );
        }
      }

      if (mounted) {
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

  // Handle delete
  Future<void> _deleteAccount() async {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: isDark ? const Color(0xFF1E2420) : Colors.white,
          title: Text(
            t.accounts.edit.delete_title,
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            t.accounts.edit.delete_message,
            style: const TextStyle(
              fontFamily: 'Epilogue',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                t.common.cancel,
                style: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xFF5D6B60),
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.error,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                t.common.delete,
                style: const TextStyle(
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(accountsRepositoryProvider).delete(widget.accountId);
      if (mounted) {
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

    final accountAsync = ref.watch(accountByIdProvider(widget.accountId));
    final txsAsync = ref.watch(transactionsByAccountProvider(widget.accountId));

    final labelStyle = TextStyle(
      fontFamily: 'Epilogue',
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: isDark ? Colors.white70 : const Color(0xFF5D6B60),
    );

    final balanceTextStyle = const TextStyle(
      fontFamily: 'Epilogue',
      fontWeight: FontWeight.bold,
      fontSize: 28,
    );

    return accountAsync.when(
      loading: () => Scaffold(
        backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(child: Text('${t.accounts.edit.error_loading}: $err')),
      ),
      data: (account) {
        if (account == null) {
          return Scaffold(
            backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: Center(child: Text(t.accounts.edit.error_loading)),
          );
        }

        // Setup values once when loaded
        if (!_isInitialized) {
          _nameController.text = account.name;
          _selectedIconName = account.icon;
          _selectedType = account.type;
          _selectedCurrency = account.currencyCode;

          txsAsync.whenData((txs) {
            Transaction? initialTx;
            for (final tx in txs) {
              if (tx.note == 'Initial Balance') {
                initialTx = tx;
                break;
              }
            }
            if (initialTx != null) {
              _initialBalanceTxId = initialTx.id;
              _balanceController.text = initialTx.amount.toStringAsFixed(2);
            }
          });

          _isInitialized = true;
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
              ),
            ),
            title: Text(
              t.accounts.edit.title,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: context.colorScheme.primary,
              ),
            ),
          ),
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                  child: Form(
                    key: _formKey,
                    child: Container(
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
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Icon Picker Section
                          Text(t.accounts.create.icon, style: labelStyle),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ..._quickIcons.map((iconName) {
                                final isSelected = _selectedIconName == iconName;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedIconName = iconName;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 48,
                                      height: 48,
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
                                  ),
                                );
                              }),
                              // Trigger custom popup bottom sheet
                              InkWell(
                                onTap: _showIconPicker,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF171B18) : const Color(0xFFF0F4F1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? Colors.white12 : const Color(0xFFDCE3DF),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.more_horiz_rounded,
                                    color: isDark ? Colors.white70 : context.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Name Input
                          Text(t.accounts.create.name, style: labelStyle),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(fontFamily: 'Epilogue', fontSize: 16),
                            decoration: InputDecoration(
                              hintText: t.accounts.create.name_hint,
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
                                return t.accounts.create.name_required;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Account Type Select Dropdown
                          Text(t.accounts.create.type, style: labelStyle),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF171B18) : const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<AccountType>(
                                value: _selectedType,
                                isExpanded: true,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                                ),
                                style: TextStyle(
                                  fontFamily: 'Epilogue',
                                  fontSize: 16,
                                  color: isDark ? Colors.white : const Color(0xFF1C221E),
                                ),
                                dropdownColor: isDark ? const Color(0xFF1E2420) : Colors.white,
                                items: [
                                  DropdownMenuItem(
                                    value: AccountType.bankAccount,
                                    child: Text(t.accounts.create.type_savings),
                                  ),
                                  DropdownMenuItem(
                                    value: AccountType.cash,
                                    child: Text(t.accounts.create.type_cash),
                                  ),
                                  DropdownMenuItem(
                                    value: AccountType.creditCard,
                                    child: Text(t.accounts.create.type_credit_card),
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
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Currency Selection Screen Push Trigger
                          Text(t.accounts.create.currency, style: labelStyle),
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
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF171B18) : const Color(0xFFFAFAFA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$_selectedCurrency (${_getCurrencySymbol(_selectedCurrency)})',
                                    style: const TextStyle(
                                      fontFamily: 'Epilogue',
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Initial Balance Input
                          Text(t.accounts.create.initial_balance, style: labelStyle),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _balanceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: balanceTextStyle,
                            decoration: InputDecoration(
                              hintText: '0.00',
                              hintStyle: balanceTextStyle.copyWith(
                                color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                              ),
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
                                  return t.accounts.create.balance_invalid;
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Pro Tip Info Card matching Verdant Horizon design system
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? context.colorScheme.primary.withValues(alpha: 0.1) : const Color(0xFFF2F6F3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? context.colorScheme.primary.withValues(alpha: 0.2) : const Color(0xFFE3EAE5),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.lightbulb_outline_rounded,
                                  color: context.colorScheme.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Epilogue',
                                        fontSize: 13,
                                        height: 1.5,
                                        color: isDark ? Colors.white70 : const Color(0xFF2E3B32),
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
                                          text: t.accounts.create.pro_tip.substring(9),
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

              // Bottom floating custom actions (Save and Delete Buttons)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        isDark ? const Color(0xFF171B18).withValues(alpha: 0.0) : const Color(0xFFF9FAF9).withValues(alpha: 0.0),
                        isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Save Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(56),
                            elevation: 8,
                            shadowColor: context.colorScheme.primary.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.edit_note_rounded, size: 24),
                                    const SizedBox(width: 8),
                                    Text(
                                      t.accounts.edit.edit_button,
                                      style: const TextStyle(
                                        fontFamily: 'Epilogue',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 12),

                        // Delete Button
                        TextButton(
                          onPressed: _isLoading ? null : _deleteAccount,
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline_rounded, color: context.colorScheme.error, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                t.accounts.edit.delete_button,
                                style: TextStyle(
                                  color: context.colorScheme.error,
                                  fontFamily: 'Epilogue',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
            ],
          ),
        );
      },
    );
  }
}
