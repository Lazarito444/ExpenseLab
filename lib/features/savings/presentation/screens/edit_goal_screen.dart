import 'package:drift/drift.dart' as drift;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/formatters/currency_input_formatter.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/savings/domain/models/savings_goal_model.dart';
import 'package:expenselab/features/savings/providers/savings_providers.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ── Entry point: loads goal then hands off to form ───────────────────────────

class EditGoalScreen extends ConsumerWidget {
  const EditGoalScreen({required this.goalId, super.key});

  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final goalAsync = ref.watch(savingsGoalByIdProvider(goalId));

    return goalAsync.when(
      loading: () => Scaffold(
        backgroundColor: context.appColors.scaffoldBackground,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: ExpenseLabAppBar(
          title: t.goals.edit.title,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text(t.goals.edit.error_loading)),
      ),
      data: (goal) {
        if (goal == null) {
          return Scaffold(
            appBar: ExpenseLabAppBar(
              title: t.goals.edit.title,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(child: Text(t.goals.edit.error_loading)),
          );
        }
        return _EditGoalForm(goal: goal);
      },
    );
  }
}

// ── Form (stateful, initialised from the already-loaded goal) ────────────────

class _EditGoalForm extends ConsumerStatefulWidget {
  const _EditGoalForm({required this.goal});

  final SavingsGoalModel goal;

  @override
  ConsumerState<_EditGoalForm> createState() => _EditGoalFormState();
}

class _EditGoalFormState extends ConsumerState<_EditGoalForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  DateTime? _selectedDate;
  late String _selectedAccountId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.goal.name);
    _amountController = TextEditingController(
      text: CurrencyInputFormatter.formatForDisplay(widget.goal.targetAmount),
    );
    _selectedDate = widget.goal.targetDate;
    _selectedAccountId = widget.goal.sourceAccountId;
  }

  @override
  void dispose() {
    _nameController.dispose();
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
          .read(savingsGoalsRepositoryProvider)
          .update(
            widget.goal.id,
            SavingsGoalsCompanion(
              name: drift.Value(_nameController.text.trim()),
              targetAmount: drift.Value(amount),
              sourceAccountId: drift.Value(_selectedAccountId),
              targetDate: drift.Value(_selectedDate),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.goals.edit.success_update),
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
          t.goals.edit.delete_title,
          style: const TextStyle(fontFamily: 'Epilogue', fontWeight: FontWeight.w700),
        ),
        content: Text(
          t.goals.edit.delete_message,
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
      await ref.read(savingsGoalsRepositoryProvider).delete(widget.goal.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.goals.edit.success_delete),
            backgroundColor: const Color(0xFF2D6831),
          ),
        );
        context.pop();
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
                t.goals.edit.associated_account,
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
                      trailing: isSelected
                          ? Icon(Icons.check_rounded, color: context.colorScheme.primary)
                          : null,
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final currency = ref.watch(currencyProvider);
    final accounts = ref.watch(accountModelsProvider);

    final selectedAccount = accounts.where((a) => a.id == _selectedAccountId).firstOrNull;

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: t.goals.edit.title,
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
                            decoration: _fieldDecoration(context: context),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return t.goals.create.name_required;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel(label: t.goals.create.target_amount),
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
                              prefixText: '${currency.symbol}  ',
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
                          _DateSelectorField(date: _selectedDate, onTap: _pickDate),
                          const SizedBox(height: 16),

                          _FieldLabel(label: t.goals.edit.associated_account),
                          const SizedBox(height: 8),
                          _AccountSelectorField(
                            label: selectedAccount?.name ?? t.goals.create.select_account,
                            isEmpty: selectedAccount == null,
                            onTap: accounts.isEmpty
                                ? null
                                : () => _showAccountSheet(context, accounts, t),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                  child: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          t.goals.edit.save_button,
                          style: const TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _isLoading ? null : () => _delete(t),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: Text(
                t.goals.edit.delete_button,
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
        fontWeight: FontWeight.w600,
        color: context.colorScheme.primary,
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
