import 'package:drift/drift.dart' as drift;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/formatters/currency_input_formatter.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/savings/providers/savings_providers.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedAccountId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _submit(Translations t) async {
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.goals.create.account_required)),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
      await ref
          .read(savingsGoalsRepositoryProvider)
          .create(
            SavingsGoalsCompanion(
              name: drift.Value(_nameController.text.trim()),
              targetAmount: drift.Value(amount),
              sourceAccountId: drift.Value(_selectedAccountId!),
              targetDate: drift.Value(_selectedDate),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.goals.create.success),
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _showAccountSheet(
    BuildContext context,
    List<AccountModel> accounts,
    Translations t,
  ) {
    final appColors = context.appColors;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: appColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, sc) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              _SheetHandle(),
              const SizedBox(height: 16),
              Text(
                t.goals.create.source_account,
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
                  itemCount: accounts.length,
                  itemBuilder: (_, i) {
                    final acc = accounts[i];
                    final isSelected = acc.id == _selectedAccountId;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        acc.name,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? context.colorScheme.primary : appColors.primaryText,
                        ),
                      ),
                      trailing: isSelected ? Icon(Icons.check_rounded, color: context.colorScheme.primary) : null,
                      onTap: () {
                        setState(() => _selectedAccountId = acc.id);
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  InputDecoration _fieldDecoration({
    required BuildContext context,
    String? hint,
    String? prefixText,
    Widget? suffixIcon,
    bool enabled = true,
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
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: enabled ? appColors.inputFill : appColors.inputFill.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appColors.inputBorder),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appColors.inputBorder.withValues(alpha: 0.5)),
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accounts = ref.watch(accountModelsProvider);

    final selectedAccount = _selectedAccountId != null ? accounts.where((a) => a.id == _selectedAccountId).firstOrNull : null;

    final accountCurrencySymbol = selectedAccount != null
        ? kSupportedCurrencies
              .firstWhere(
                (c) => c.code == selectedAccount.currencyCode,
                orElse: () => kUsdCurrency,
              )
              .symbol
        : null;

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
          onPressed: () => context.pop(),
        ),
        title: t.goals.create.title,
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
                          _FieldLabel(label: t.goals.create.name),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 14,
                              color: context.appColors.primaryText,
                            ),
                            decoration: _fieldDecoration(
                              context: context,
                              hint: t.goals.create.name_hint,
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return t.goals.create.name_required;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel(label: t.goals.create.source_account),
                          const SizedBox(height: 8),
                          _AccountSelectorField(
                            label: selectedAccount?.name ?? t.goals.create.select_account,
                            isEmpty: selectedAccount == null,
                            onTap: accounts.isEmpty ? null : () => _showAccountSheet(context, accounts, t),
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel(
                            label: t.goals.create.target_amount,
                            muted: selectedAccount == null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _amountController,
                            enabled: selectedAccount != null,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [CurrencyInputFormatter()],
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 14,
                              color: context.appColors.primaryText,
                            ),
                            decoration: _fieldDecoration(
                              context: context,
                              prefixText: accountCurrencySymbol != null ? '$accountCurrencySymbol  ' : null,
                              enabled: selectedAccount != null,
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return t.goals.create.amount_required;
                              }
                              if (double.tryParse(v.replaceAll(',', '')) == null) {
                                return t.goals.create.amount_invalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel(label: t.goals.create.target_date),
                          const SizedBox(height: 8),
                          _DateSelectorField(
                            date: _selectedDate,
                            onTap: _pickDate,
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
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _submit(t),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColors.actionButtonBg,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    t.goals.create.create_button,
                    style: const TextStyle(fontFamily: 'Epilogue', fontSize: 15, fontWeight: FontWeight.w600),
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
  const _FieldLabel({required this.label, this.muted = false});

  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: muted ? context.appColors.secondaryLabel : context.colorScheme.primary,
      ),
    );
  }
}

class _DateSelectorField extends StatelessWidget {
  const _DateSelectorField({required this.date, required this.onTap});

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final hasDate = date != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              hasDate ? DateFormat('dd/MM/yyyy').format(date!) : 'dd/mm/yyyy',
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 14,
                color: hasDate ? appColors.primaryText : appColors.secondaryLabel,
              ),
            ),
            Icon(Icons.calendar_today_outlined, size: 18, color: appColors.secondaryLabel),
          ],
        ),
      ),
    );
  }
}

class _AccountSelectorField extends StatelessWidget {
  const _AccountSelectorField({
    required this.label,
    required this.isEmpty,
    required this.onTap,
  });

  final String label;
  final bool isEmpty;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: appColors.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.inputBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            Icon(Icons.keyboard_arrow_down_rounded, size: 22, color: appColors.secondaryLabel),
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
