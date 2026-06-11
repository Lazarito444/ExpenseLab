import 'package:drift/drift.dart' as drift;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/formatters/currency_input_formatter.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ── Icon categories for the picker ───────────────────────────────────────────

final _kIconCategories = <(String, List<String>)>[
  (
    'Finance',
    [
      'account_balance_wallet',
      'savings',
      'account_balance',
      'credit_card',
      'cash',
      'wallet',
      'payments',
      'local_atm',
      'attach_money',
      'currency_exchange',
      'paid',
      'money',
      'euro',
    ],
  ),
  (
    'Food & Dining',
    [
      'restaurant',
      'fastfood',
      'local_cafe',
      'local_grocery_store',
      'lunch_dining',
      'cake',
      'local_bar',
      'wine_bar',
    ],
  ),
  (
    'Transport',
    [
      'directions_car',
      'flight',
      'train',
      'directions_bus',
      'directions_bike',
      'motorcycle',
      'local_taxi',
      'local_gas_station',
    ],
  ),
  ('Home', ['home', 'bolt', 'wifi', 'phone', 'water_drop', 'plumbing']),
  (
    'Health',
    [
      'medical_services',
      'fitness_center',
      'health_and_safety',
      'spa',
      'self_improvement',
    ],
  ),
  (
    'Entertainment',
    [
      'movie',
      'music_note',
      'sports_esports',
      'sports_basketball',
      'sports_soccer',
      'camera_alt',
      'celebration',
      'nightlife',
    ],
  ),
  (
    'Shopping',
    [
      'shopping_bag',
      'shopping_cart',
      'storefront',
      'card_giftcard',
    ],
  ),
  (
    'Work & Education',
    [
      'work',
      'school',
      'computer',
      'menu_book',
      'science',
      'construction',
      'business_center',
    ],
  ),
  ('Travel', ['hotel', 'luggage', 'beach_access', 'card_travel']),
  (
    'Other',
    [
      'pets',
      'child_care',
      'volunteer_activism',
      'show_chart',
      'trending_up',
      'analytics',
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  String _selectedIcon = _kIconCategories.first.$2.first;
  AccountType _selectedType = AccountType.bankAccount;
  late String _selectedCurrencyCode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCurrencyCode = ref.read(currencyProvider).code;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Currency get _currency => kSupportedCurrencies.firstWhere(
    (c) => c.code == _selectedCurrencyCode,
    orElse: () => kUsdCurrency,
  );

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final accountRepo = ref.read(accountsRepositoryProvider);
      final txRepo = ref.read(transactionsRepositoryProvider);

      final accountId = await accountRepo.create(
        AccountsCompanion(
          name: drift.Value(_nameController.text.trim()),
          type: drift.Value(_selectedType),
          currencyCode: drift.Value(_selectedCurrencyCode),
          icon: drift.Value(_selectedIcon),
        ),
      );

      final balance = double.tryParse(_balanceController.text.replaceAll(',', '')) ?? 0.0;
      if (balance > 0) {
        await txRepo.create(
          TransactionsCompanion(
            type: const drift.Value(TransactionType.income),
            amount: drift.Value(balance),
            date: drift.Value(DateTime.now()),
            accountId: drift.Value(accountId),
            note: const drift.Value('Initial balance'),
          ),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.accounts.create.success),
            backgroundColor: const Color(0xFF2D6831),
          ),
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

  // ── Bottom sheets ──────────────────────────────────────────────────────────

  void _showTypeSheet(BuildContext context, Translations t) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 16),
            Text(
              t.accounts.create.type,
              style: const TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...AccountType.values.map((type) {
              final label = _typeLabel(t, type);
              final isSelected = type == _selectedType;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? const Color(0xFF2D6831) : const Color(0xFF1A1A1A),
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF2D6831),
                      )
                    : null,
                onTap: () {
                  setState(() => _selectedType = type);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showCurrencySheet(BuildContext context, Translations t) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              const _SheetHandle(),
              const SizedBox(height: 16),
              Text(
                t.accounts.create.select_currency_title,
                style: const TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: kSupportedCurrencies.length,
                  itemBuilder: (_, i) {
                    final cur = kSupportedCurrencies[i];
                    final isSelected = cur.code == _selectedCurrencyCode;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${cur.code} (${cur.symbol})',
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? const Color(0xFF2D6831) : const Color(0xFF1A1A1A),
                        ),
                      ),
                      subtitle: Text(
                        cur.name,
                        style: const TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 12,
                          color: Color(0xFF9EAEA2),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF2D6831),
                            )
                          : null,
                      onTap: () {
                        setState(() => _selectedCurrencyCode = cur.code);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIconSheet(BuildContext context, Translations t) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              const _SheetHandle(),
              const SizedBox(height: 16),
              Text(
                t.accounts.create.icon,
                style: const TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    for (final (category, icons) in _kIconCategories) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9EAEA2),
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: icons.map((name) {
                          final selected = name == _selectedIcon;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedIcon = name);
                              Navigator.pop(sheetContext);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: selected ? const Color(0xFF2D6831) : const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                iconFromName(name),
                                color: selected ? Colors.white : const Color(0xFF8E8E8E),
                                size: 22,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _typeLabel(Translations t, AccountType type) => switch (type) {
    AccountType.cash => t.accounts.create.type_cash,
    AccountType.bankAccount => t.accounts.create.type_savings,
    AccountType.creditCard => t.accounts.create.type_credit_card,
  };

  InputDecoration _fieldDecoration({String? hint, Widget? prefix}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontFamily: 'Epilogue',
      color: Color(0xFFBDBDBD),
      fontSize: 14,
    ),
    prefix: prefix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2D6831), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Scaffold(
      appBar: ExpenseLabAppBar(
        title: t.accounts.create.title,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colorScheme.primary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable form ──────────────────────────────────────────
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account Icon
                      _SectionLabel(label: t.accounts.create.icon),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _showIconSheet(context, t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE5E5E5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2D6831),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  iconFromName(_selectedIcon),
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  toBeginningOfSentenceCase(_selectedIcon.replaceAll('_', ' ')),
                                  style: const TextStyle(
                                    fontFamily: 'Epilogue',
                                    fontSize: 14,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey.shade500,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Account Name
                      _SectionLabel(label: t.accounts.create.name),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 14,
                        ),
                        decoration: _fieldDecoration(
                          hint: t.accounts.create.name_hint,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return t.accounts.create.name_required;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),

                      // Account Type
                      _SectionLabel(label: t.accounts.create.type),
                      const SizedBox(height: 10),
                      _SelectorField(
                        value: _typeLabel(t, _selectedType),
                        onTap: () => _showTypeSheet(context, t),
                      ),
                      const SizedBox(height: 22),

                      // Currency
                      _SectionLabel(label: t.accounts.create.currency),
                      const SizedBox(height: 10),
                      _SelectorField(
                        value: '${_currency.code} (${_currency.symbol})',
                        onTap: () => _showCurrencySheet(context, t),
                      ),
                      const SizedBox(height: 22),

                      // Initial Balance
                      _SectionLabel(label: t.accounts.create.initial_balance),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _balanceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [CurrencyInputFormatter()],
                        style: const TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 14,
                        ),
                        decoration: _fieldDecoration(
                          hint: '0.00',
                          prefix: Text(
                            '${_currency.symbol}  ',
                            style: const TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 14,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return null;
                          if (double.tryParse(v.replaceAll(',', '')) == null) {
                            return t.accounts.create.balance_invalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Pro Tip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F8F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.tips_and_updates_outlined,
                              color: Color(0xFF2D6831),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${t.accounts.create.pro_tip_label}: ',
                                      style: const TextStyle(
                                        fontFamily: 'Epilogue',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2D6831),
                                      ),
                                    ),
                                    TextSpan(
                                      text: t.accounts.create.pro_tip,
                                      style: const TextStyle(
                                        fontFamily: 'Epilogue',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF4A6E4A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // ── Pinned Create Account button ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.account_balance_wallet_rounded, size: 20),
                  label: Text(
                    t.accounts.create.create_button,
                    style: const TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6831),
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
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2D6831),
      ),
    );
  }
}

class _SelectorField extends StatelessWidget {
  const _SelectorField({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 14,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade500,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
