import 'package:drift/drift.dart' as drift;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/formatters/currency_input_formatter.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/budgets/providers/budgets_providers.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateBudgetScreen extends ConsumerStatefulWidget {
  const CreateBudgetScreen({super.key});

  @override
  ConsumerState<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends ConsumerState<CreateBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedCurrencyCode;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _submit(Translations t) async {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.budgets.create.category_required)),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
      await ref.read(budgetsRepositoryProvider).create(
        BudgetsCompanion(
          categoryId: drift.Value(_selectedCategoryId!),
          amount: drift.Value(amount),
          startDate: drift.Value(DateTime.now()),
          rrule: const drift.Value('FREQ=MONTHLY'),
          currencyCode: drift.Value(_selectedCurrencyCode ?? ref.read(currencyProvider).code),
        ),
      );
      if (mounted) {
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

  void _showCategorySheet(BuildContext context, List categories, Translations t) {
    final appColors = context.appColors;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: appColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, sc) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              _SheetHandle(),
              const SizedBox(height: 16),
              Text(
                t.budgets.create.category,
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
                  controller: sc,
                  itemCount: categories.length,
                  itemBuilder: (_, i) {
                    final cat = categories[i];
                    final isSelected = cat.id == _selectedCategoryId;
                    final catColor = Color(cat.color);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(iconFromName(cat.icon), color: catColor, size: 18),
                      ),
                      title: Text(
                        cat.name,
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
                        setState(() => _selectedCategoryId = cat.id);
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

  void _showCurrencySheet(BuildContext context, Translations t) {
    final appColors = context.appColors;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: appColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, sc) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              _SheetHandle(),
              const SizedBox(height: 16),
              Text(
                t.budgets.create.currency,
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
                  controller: sc,
                  itemCount: kSupportedCurrencies.length,
                  itemBuilder: (_, i) {
                    final c = kSupportedCurrencies[i];
                    final isSelected = c.code == (_selectedCurrencyCode ?? kUsdCurrency.code);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${c.code} (${c.symbol})',
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
                        setState(() => _selectedCurrencyCode = c.code);
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final defaultCurrency = ref.watch(currencyProvider);
    final categories = (ref.watch(categoriesProvider).value ?? [])
        .where((c) => c.type == CategoryType.expense && !c.isDeleted)
        .toList();

    final currencyCode = _selectedCurrencyCode ?? defaultCurrency.code;
    final currencySymbol = kSupportedCurrencies
        .firstWhere((c) => c.code == currencyCode, orElse: () => kUsdCurrency)
        .symbol;

    final selectedCategory = _selectedCategoryId != null
        ? categories.where((c) => c.id == _selectedCategoryId).firstOrNull
        : null;

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: t.budgets.create.title,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _FormCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel(label: t.budgets.create.category),
                          const SizedBox(height: 8),
                          _SelectorField(
                            label: selectedCategory?.name ?? t.budgets.create.select_category,
                            isEmpty: selectedCategory == null,
                            leadingIcon: selectedCategory != null
                                ? Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: Color(selectedCategory.color).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      iconFromName(selectedCategory.icon),
                                      color: Color(selectedCategory.color),
                                      size: 16,
                                    ),
                                  )
                                : null,
                            trailingIcon: Icons.chevron_right_rounded,
                            onTap: () => _showCategorySheet(context, categories, t),
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel(label: t.budgets.create.currency),
                          const SizedBox(height: 8),
                          _SelectorField(
                            label: '$currencyCode ($currencySymbol)',
                            isEmpty: false,
                            trailingIcon: Icons.keyboard_arrow_down_rounded,
                            onTap: () => _showCurrencySheet(context, t),
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel(label: t.budgets.create.amount),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [CurrencyInputFormatter()],
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 14,
                              color: context.appColors.primaryText,
                            ),
                            decoration: _fieldDecoration(
                              context: context,
                              prefixText: '$currencySymbol  ',
                              hint: '0.00',
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return t.budgets.create.amount_required;
                              if (double.tryParse(v.replaceAll(',', '')) == null) {
                                return t.budgets.create.amount_invalid;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : () => _submit(t),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline_rounded, size: 20),
                  label: Text(
                    t.budgets.create.create_button,
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
  }
}

// ── Shared form helpers ───────────────────────────────────────────────────────

InputDecoration _fieldDecoration({
  required BuildContext context,
  String? hint,
  String? prefixText,
}) {
  final appColors = context.appColors;
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      fontFamily: 'Epilogue',
      color: appColors.secondaryLabel,
      fontSize: 14,
    ),
    prefixText: prefixText,
    prefixStyle: TextStyle(
      fontFamily: 'Epilogue',
      fontSize: 14,
      color: appColors.primaryText,
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

class _FormCard extends StatelessWidget {
  const _FormCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

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
  const _SelectorField({
    required this.label,
    required this.isEmpty,
    required this.onTap,
    this.leadingIcon,
    this.trailingIcon = Icons.keyboard_arrow_down_rounded,
  });

  final String label;
  final bool isEmpty;
  final VoidCallback onTap;
  final Widget? leadingIcon;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: appColors.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.inputBorder),
        ),
        child: Row(
          children: [
            if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 10)],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  color: isEmpty ? appColors.secondaryLabel : appColors.primaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(trailingIcon, size: 22, color: appColors.secondaryLabel),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
