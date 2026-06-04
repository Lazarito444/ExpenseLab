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

// ── Entry point: loads budget then hands off to form ─────────────────────────

class EditBudgetScreen extends ConsumerWidget {
  const EditBudgetScreen({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = context.t;
    final budgetAsync = ref.watch(budgetByIdProvider(budgetId));

    return budgetAsync.when(
      loading: () => Scaffold(
        backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: ExpenseLabAppBar(
          title: t.budgets.edit.title,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text(t.budgets.edit.error_loading)),
      ),
      data: (budget) {
        if (budget == null) {
          return Scaffold(
            appBar: ExpenseLabAppBar(
              title: t.budgets.edit.title,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(child: Text(t.budgets.edit.error_loading)),
          );
        }
        return _EditBudgetForm(budget: budget);
      },
    );
  }
}

// ── Form (stateful, initialised from the loaded budget) ──────────────────────

class _EditBudgetForm extends ConsumerStatefulWidget {
  const _EditBudgetForm({required this.budget});

  final Budget budget;

  @override
  ConsumerState<_EditBudgetForm> createState() => _EditBudgetFormState();
}

class _EditBudgetFormState extends ConsumerState<_EditBudgetForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late String _selectedCategoryId;
  String? _selectedCurrencyCode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: CurrencyInputFormatter.formatForDisplay(widget.budget.amount),
    );
    _selectedCategoryId = widget.budget.categoryId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _submit(Translations t) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
      await ref
          .read(budgetsRepositoryProvider)
          .update(
            widget.budget.id,
            BudgetsCompanion(
              categoryId: drift.Value(_selectedCategoryId),
              amount: drift.Value(amount),
              rrule: const drift.Value('FREQ=MONTHLY'),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.budgets.edit.success_update),
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

  Future<void> _delete(Translations t) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          t.budgets.edit.delete_title,
          style: const TextStyle(fontFamily: 'Epilogue', fontWeight: FontWeight.w700),
        ),
        content: Text(
          t.budgets.edit.delete_message,
          style: const TextStyle(fontFamily: 'Epilogue'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(t.common.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(budgetsRepositoryProvider).delete(widget.budget.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.budgets.edit.success_delete),
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

  void _showCategorySheet(BuildContext context, List categories, Translations t, bool isDark) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E2420) : Colors.white,
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
                  color: isDark ? Colors.white : const Color(0xFF0F1E36),
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
                          color: isSelected ? const Color(0xFF2D6831) : (isDark ? Colors.white : const Color(0xFF1A1A1A)),
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check_rounded, color: Color(0xFF2D6831)) : null,
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

  void _showCurrencySheet(BuildContext context, String defaultCode, Translations t, bool isDark) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E2420) : Colors.white,
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
                  color: isDark ? Colors.white : const Color(0xFF0F1E36),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  controller: sc,
                  itemCount: kSupportedCurrencies.length,
                  itemBuilder: (_, i) {
                    final c = kSupportedCurrencies[i];
                    final effectiveCode = _selectedCurrencyCode ?? defaultCode;
                    final isSelected = c.code == effectiveCode;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${c.code} (${c.symbol})',
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? const Color(0xFF2D6831) : (isDark ? Colors.white : const Color(0xFF1A1A1A)),
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check_rounded, color: Color(0xFF2D6831)) : null,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultCurrency = ref.watch(currencyProvider);
    final categories = (ref.watch(categoriesProvider).value ?? [])
        .where((c) => c.type == CategoryType.expense && !c.isDeleted)
        .toList();

    final currencyCode = _selectedCurrencyCode ?? defaultCurrency.code;
    final currencySymbol = kSupportedCurrencies.firstWhere((c) => c.code == currencyCode, orElse: () => kUsdCurrency).symbol;

    final selectedCategory = categories.where((c) => c.id == _selectedCategoryId).firstOrNull;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
      appBar: ExpenseLabAppBar(
        title: t.budgets.edit.title,
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
                      isDark: isDark,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category
                          _FieldLabel(label: t.budgets.create.category, isDark: isDark),
                          const SizedBox(height: 8),
                          _SelectorField(
                            label: selectedCategory?.name ?? t.budgets.create.select_category,
                            isEmpty: selectedCategory == null,
                            isDark: isDark,
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
                            onTap: () => _showCategorySheet(context, categories, t, isDark),
                          ),
                          const SizedBox(height: 16),

                          // Currency
                          _FieldLabel(label: t.budgets.create.currency, isDark: isDark),
                          const SizedBox(height: 8),
                          _SelectorField(
                            label: '$currencyCode ($currencySymbol)',
                            isEmpty: false,
                            isDark: isDark,
                            trailingIcon: Icons.keyboard_arrow_down_rounded,
                            onTap: () => _showCurrencySheet(context, defaultCurrency.code, t, isDark),
                          ),
                          const SizedBox(height: 16),

                          // Amount
                          _FieldLabel(label: t.budgets.create.amount, isDark: isDark),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [CurrencyInputFormatter()],
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 14,
                              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            ),
                            decoration: _fieldDecoration(
                              prefixText: '$currencySymbol  ',
                              isDark: isDark,
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

            // ── Pinned save button ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                      : const Icon(Icons.save_outlined, size: 20),
                  label: Text(
                    t.budgets.edit.edit_button,
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
            TextButton.icon(
              onPressed: _isLoading ? null : () => _delete(t),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: Text(
                t.budgets.edit.delete_button,
                style: const TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade600),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ── Shared form helpers ───────────────────────────────────────────────────────

InputDecoration _fieldDecoration({
  String? hint,
  String? prefixText,
  bool isDark = false,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      fontFamily: 'Epilogue',
      color: isDark ? Colors.white24 : const Color(0xFFBDBDBD),
      fontSize: 14,
    ),
    prefixText: prefixText,
    prefixStyle: TextStyle(
      fontFamily: 'Epilogue',
      fontSize: 14,
      color: isDark ? Colors.white70 : const Color(0xFF1A1A1A),
    ),
    filled: true,
    fillColor: isDark ? const Color(0xFF2A312C) : Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: isDark ? Colors.white12 : const Color(0xFFE5E5E5)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: isDark ? Colors.white12 : const Color(0xFFE5E5E5)),
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
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2420) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
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
  const _FieldLabel({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: isDark ? const Color(0xFF6DBF6F) : const Color(0xFF2D6831),
      ),
    );
  }
}

class _SelectorField extends StatelessWidget {
  const _SelectorField({
    required this.label,
    required this.isEmpty,
    required this.isDark,
    required this.onTap,
    this.leadingIcon,
    this.trailingIcon = Icons.keyboard_arrow_down_rounded,
  });

  final String label;
  final bool isEmpty;
  final bool isDark;
  final VoidCallback onTap;
  final Widget? leadingIcon;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A312C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xFFE5E5E5),
          ),
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
                  color: isEmpty ? (isDark ? Colors.white24 : const Color(0xFFBDBDBD)) : (isDark ? Colors.white : const Color(0xFF1A1A1A)),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              trailingIcon,
              size: 22,
              color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
            ),
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
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
