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
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// â”€â”€ Icon categories for the picker â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

final _kIconCategories = <(String, List<String>)>[
  ('Finance', [
    'account_balance_wallet', 'savings', 'account_balance', 'credit_card',
    'cash', 'wallet', 'payments', 'local_atm', 'attach_money',
    'currency_exchange', 'paid', 'money', 'euro',
  ]),
  ('Food & Dining', [
    'restaurant', 'fastfood', 'local_cafe', 'local_grocery_store',
    'lunch_dining', 'cake', 'local_bar', 'wine_bar',
  ]),
  ('Transport', [
    'directions_car', 'flight', 'train', 'directions_bus',
    'directions_bike', 'motorcycle', 'local_taxi', 'local_gas_station',
  ]),
  ('Home', ['home', 'bolt', 'wifi', 'phone', 'water_drop', 'plumbing']),
  ('Health', [
    'medical_services', 'fitness_center', 'health_and_safety',
    'spa', 'self_improvement',
  ]),
  ('Entertainment', [
    'movie', 'music_note', 'sports_esports', 'sports_basketball',
    'sports_soccer', 'camera_alt', 'celebration', 'nightlife',
  ]),
  ('Shopping', [
    'shopping_bag', 'shopping_cart', 'storefront', 'card_giftcard',
  ]),
  ('Work & Education', [
    'work', 'school', 'computer', 'menu_book',
    'science', 'construction', 'business_center',
  ]),
  ('Travel', ['hotel', 'luggage', 'beach_access', 'card_travel']),
  ('Other', [
    'pets', 'child_care', 'volunteer_activism',
    'show_chart', 'trending_up', 'analytics',
  ]),
];

// â”€â”€ Screen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class EditAccountScreen extends ConsumerStatefulWidget {
  const EditAccountScreen({required this.accountId, super.key});

  final String accountId;

  @override
  ConsumerState<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends ConsumerState<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  String _selectedIcon = _kIconCategories.first.$2.first;
  AccountType _selectedType = AccountType.bankAccount;
  String _selectedCurrencyCode = 'USD';
  double _originalBalance = 0.0;
  bool _initialized = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  /// Idempotent initialisation â€” runs once when account data first arrives.
  void _initFrom(Account account, double balance) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = account.name;
    _balanceController.text = CurrencyInputFormatter.formatForDisplay(balance);
    _selectedIcon = account.icon;
    _selectedType = account.type;
    _selectedCurrencyCode = account.currencyCode;
    _originalBalance = balance;
  }

  Currency get _currency => kSupportedCurrencies.firstWhere(
    (c) => c.code == _selectedCurrencyCode,
    orElse: () => kUsdCurrency,
  );

  // â”€â”€ Submit â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final accountRepo = ref.read(accountsRepositoryProvider);
      final txRepo = ref.read(transactionsRepositoryProvider);

      await accountRepo.update(
        widget.accountId,
        AccountsCompanion(
          name: drift.Value(_nameController.text.trim()),
          type: drift.Value(_selectedType),
          currencyCode: drift.Value(_selectedCurrencyCode),
          icon: drift.Value(_selectedIcon),
        ),
      );

      final newBalance =
          double.tryParse(_balanceController.text.replaceAll(',', '')) ??
          _originalBalance;
      final diff = newBalance - _originalBalance;
      if (diff.abs() > 0.001) {
        await txRepo.create(
          TransactionsCompanion(
            type: drift.Value(
              diff > 0 ? TransactionType.income : TransactionType.expense,
            ),
            amount: drift.Value(diff.abs()),
            date: drift.Value(DateTime.now()),
            accountId: drift.Value(widget.accountId),
            note: const drift.Value('Balance adjustment'),
          ),
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t.accounts.edit.success_update),
          backgroundColor: context.colorScheme.primary,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // â”€â”€ Delete â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _confirmDelete(BuildContext context, Translations t) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          t.accounts.edit.delete_title,
          style: const TextStyle(
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: Text(
          t.accounts.edit.delete_message,
          style: const TextStyle(fontFamily: 'Epilogue', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              t.common.cancel,
              style: const TextStyle(
                fontFamily: 'Epilogue',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              t.common.delete,
              style: const TextStyle(
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(accountsRepositoryProvider).delete(widget.accountId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.accounts.edit.success_delete),
          backgroundColor: context.colorScheme.primary,
        ),
      );
      context.pop();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // â”€â”€ Bottom sheets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  void _showTypeSheet(BuildContext context, Translations t) {
    final appColors = context.appColors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: appColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sheetHandle(context),
            const SizedBox(height: 16),
            Text(
              t.accounts.create.type,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: appColors.primaryText,
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
                    color: isSelected ? context.colorScheme.primary : appColors.primaryText,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_rounded, color: context.colorScheme.primary)
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
    final appColors = context.appColors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: appColors.cardSurface,
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
              _sheetHandle(context),
              const SizedBox(height: 16),
              Text(
                t.accounts.create.select_currency_title,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: appColors.primaryText,
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
                          color: isSelected ? context.colorScheme.primary : appColors.primaryText,
                        ),
                      ),
                      subtitle: Text(
                        cur.name,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 12,
                          color: appColors.secondaryLabel,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_rounded, color: context.colorScheme.primary)
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
    final appColors = context.appColors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: appColors.cardSurface,
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
              _sheetHandle(context),
              const SizedBox(height: 16),
              Text(
                t.accounts.create.icon,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: appColors.primaryText,
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
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: appColors.secondaryLabel,
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
                                color: selected
                                    ? context.colorScheme.primary
                                    : appColors.inputFill,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                iconFromName(name),
                                color: selected ? Colors.white : appColors.secondaryLabel,
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

  // â”€â”€ Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  String _typeLabel(Translations t, AccountType type) => switch (type) {
    AccountType.cash => t.accounts.create.type_cash,
    AccountType.bankAccount => t.accounts.create.type_savings,
    AccountType.creditCard => t.accounts.create.type_credit_card,
  };

  InputDecoration _fieldDecoration({String? hint, Widget? prefix}) {
    final appColors = context.appColors;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Epilogue',
        color: appColors.secondaryLabel,
        fontSize: 14,
      ),
      prefix: prefix,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  // â”€â”€ Build â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final appColors = context.appColors;
    final accountAsync = ref.watch(accountByIdProvider(widget.accountId));
    final balance = ref.watch(accountBalanceProvider(widget.accountId));

    final appBar = ExpenseLabAppBar(
      title: t.accounts.edit.title,
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
      error: (e, st) => Scaffold(
        backgroundColor: context.appColors.scaffoldBackground,
        appBar: appBar,
        body: Center(child: Text(t.accounts.edit.error_loading)),
      ),
      data: (account) {
        if (account == null) {
          return Scaffold(
            backgroundColor: context.appColors.scaffoldBackground,
            appBar: appBar,
            body: Center(child: Text(t.accounts.edit.error_loading)),
          );
        }

        _initFrom(account, balance);

        return Scaffold(
          backgroundColor: context.appColors.scaffoldBackground,
          appBar: appBar,
          body: SafeArea(
            child: Column(
              children: [
                // â”€â”€ Scrollable form â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
                                color: appColors.inputFill,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: appColors.inputBorder),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: context.colorScheme.primary,
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
                                      _selectedIcon.replaceAll('_', ' '),
                                      style: TextStyle(
                                        fontFamily: 'Epilogue',
                                        fontSize: 14,
                                        color: appColors.primaryText,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: appColors.secondaryLabel,
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
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 14,
                              color: appColors.primaryText,
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

                          // Current Balance
                          _SectionLabel(label: t.accounts.create.initial_balance),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _balanceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [CurrencyInputFormatter()],
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 14,
                              color: appColors.primaryText,
                            ),
                            decoration: _fieldDecoration(
                              prefix: Text(
                                '${_currency.symbol}  ',
                                style: TextStyle(
                                  fontFamily: 'Epilogue',
                                  fontSize: 14,
                                  color: appColors.primaryText,
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
                              color: context.colorScheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.tips_and_updates_outlined,
                                  color: context.colorScheme.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${t.accounts.create.pro_tip_label}: ',
                                          style: TextStyle(
                                            fontFamily: 'Epilogue',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: context.colorScheme.primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: t.accounts.create.pro_tip,
                                          style: TextStyle(
                                            fontFamily: 'Epilogue',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: context.colorScheme.primary.withValues(alpha: 0.7),
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

                // â”€â”€ Edit Account button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                          : const Icon(Icons.edit_rounded, size: 20),
                      label: Text(
                        t.accounts.edit.edit_button,
                        style: const TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ),

                // â”€â”€ Delete Account button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                TextButton.icon(
                  onPressed: _isLoading ? null : () => _confirmDelete(context, t),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 18,
                  ),
                  label: Text(
                    t.accounts.edit.delete_button,
                    style: const TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

// â”€â”€ Private widgets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: context.colorScheme.primary,
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
    final appColors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: appColors.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.inputBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 14,
                color: appColors.primaryText,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: appColors.secondaryLabel,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _sheetHandle(BuildContext context) {
  return Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: context.appColors.sheetHandle,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}
