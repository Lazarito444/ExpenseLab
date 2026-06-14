import 'package:drift/drift.dart' as drift;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/formatters/currency_input_formatter.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/savings/domain/models/savings_contribution_model.dart';
import 'package:expenselab/features/savings/domain/models/savings_goal_model.dart';
import 'package:expenselab/features/savings/providers/savings_providers.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

class GoalDetailsScreen extends ConsumerWidget {
  const GoalDetailsScreen({required this.goalId, super.key});

  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final goalAsync = ref.watch(savingsGoalByIdProvider(goalId));
    final accountModels = ref.watch(accountModelsProvider);

    return goalAsync.when(
      loading: () => Scaffold(
        backgroundColor: context.appColors.scaffoldBackground,
        appBar: _buildAppBar(context, null, t, goalId),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: _buildAppBar(context, null, t, goalId),
        body: Center(child: Text(t.goals.edit.error_loading)),
      ),
      data: (goal) {
        if (goal == null) {
          return Scaffold(
            appBar: _buildAppBar(context, null, t, goalId),
            body: Center(child: Text(t.goals.edit.error_loading)),
          );
        }

        final account = accountModels.where((a) => a.id == goal.sourceAccountId).firstOrNull;
        final currency = account != null
            ? kSupportedCurrencies.firstWhere(
                (c) => c.code == account.currencyCode,
                orElse: () => kUsdCurrency,
              )
            : kUsdCurrency;

        return _GoalDetailsBody(
          goal: goal,
          currency: currency,
          goalId: goalId,
        );
      },
    );
  }

  ExpenseLabAppBar _buildAppBar(
    BuildContext context,
    String? title,
    Translations t,
    String goalId,
  ) {
    return ExpenseLabAppBar(
      title: title,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.edit_outlined, color: context.colorScheme.primary),
          onPressed: () => context.push(AppRoutes.goalEdit(goalId)),
        ),
      ],
    );
  }
}

// ── Main body (has access to loaded goal) ─────────────────────────────────────

class _GoalDetailsBody extends ConsumerWidget {
  const _GoalDetailsBody({
    required this.goal,
    required this.currency,
    required this.goalId,
  });

  final SavingsGoalModel goal;
  final Currency currency;
  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final appColors = context.appColors;
    final contribsAsync = ref.watch(contributionsByGoalProvider(goalId));

    final contribs = contribsAsync.maybeWhen(
      data: (list) => list..sort((a, b) => b.date.compareTo(a.date)),
      orElse: () => <SavingsContributionModel>[],
    );

    final totalSaved = contribs.fold(0.0, (sum, c) => sum + c.amount);
    final progress = goal.targetAmount > 0 ? (totalSaved / goal.targetAmount).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: goal.name,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: context.colorScheme.primary),
            onPressed: () => context.push(AppRoutes.goalEdit(goalId)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'goal_details_fab',
        onPressed: () => _showAddContributionSheet(context: context, goal: goal, currency: currency, t: t),
        backgroundColor: context.appColors.actionButtonBg,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          _ProgressCard(
            goal: goal,
            totalSaved: totalSaved,
            progress: progress,
            currency: currency,
            t: t,
          ),
          const SizedBox(height: 24),
          Text(
            t.goals.details.contributions_title,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: appColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          if (contribs.isEmpty)
            _EmptyContributions(t: t)
          else
            ...contribs.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ContributionTile(contribution: c, currency: currency, t: t),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddContributionSheet({
    required BuildContext context,
    required SavingsGoalModel goal,
    required Currency currency,
    required Translations t,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddContributionSheet(goal: goal, currency: currency),
    );
  }
}

// ── Progress card ─────────────────────────────────────────────────────────────

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.goal,
    required this.totalSaved,
    required this.progress,
    required this.currency,
    required this.t,
  });

  final SavingsGoalModel goal;
  final double totalSaved;
  final double progress;
  final Currency currency;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final pct = (progress * 100).floor();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.goals.details.saved_label,
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                        color: context.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currency.format(totalSaved),
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: appColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.goals.target.replaceAll('{amount}', currency.format(goal.targetAmount)),
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 13,
                        color: appColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              _DonutProgress(progress: progress, pct: pct),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: context.colorScheme.primary.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(context.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                goal.targetDate != null ? Icons.event_rounded : Icons.event_busy_outlined,
                size: 15,
                color: appColors.secondaryLabel,
              ),
              const SizedBox(width: 6),
              Text(
                goal.targetDate != null
                    ? t.goals.details.deadline.replaceAll(
                        '{date}',
                        DateFormat('MMM d, yyyy').format(goal.targetDate!),
                      )
                    : t.goals.details.no_deadline,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 12,
                  color: appColors.secondaryLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Donut progress ────────────────────────────────────────────────────────────

class _DonutProgress extends StatelessWidget {
  const _DonutProgress({required this.progress, required this.pct});

  final double progress;
  final int pct;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: context.colorScheme.primary.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(context.colorScheme.primary),
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            '$pct%',
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: context.appColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty contributions state ─────────────────────────────────────────────────

class _EmptyContributions extends StatelessWidget {
  const _EmptyContributions({required this.t});

  final Translations t;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.savings_outlined,
            size: 48,
            color: context.colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            t.goals.details.no_contributions,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: appColors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            t.goals.details.no_contributions_subtitle,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 13,
              color: appColors.secondaryLabel,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Contribution tile ─────────────────────────────────────────────────────────

class _ContributionTile extends StatelessWidget {
  const _ContributionTile({
    required this.contribution,
    required this.currency,
    required this.t,
  });

  final SavingsContributionModel contribution;
  final Currency currency;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final label = (contribution.note?.isNotEmpty ?? false) ? contribution.note! : t.goals.details.contribution_label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: appColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.savings_rounded, color: context.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: appColors.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('MMM d, yyyy').format(contribution.date),
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 12,
                    color: appColors.secondaryLabel,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${currency.format(contribution.amount)}',
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: appColors.incomeColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add Contribution bottom sheet ─────────────────────────────────────────────

class _AddContributionSheet extends ConsumerStatefulWidget {
  const _AddContributionSheet({required this.goal, required this.currency});

  final SavingsGoalModel goal;
  final Currency currency;

  @override
  ConsumerState<_AddContributionSheet> createState() => _AddContributionSheetState();
}

class _AddContributionSheetState extends ConsumerState<_AddContributionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
      await ref
          .read(savingsContributionsRepositoryProvider)
          .create(
            SavingsContributionsCompanion(
              savingsGoalId: drift.Value(widget.goal.id),
              amount: drift.Value(amount),
              date: drift.Value(_selectedDate),
              note: drift.Value(
                _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
              ),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.goals.contribution.success),
            backgroundColor: const Color(0xFF2D6831),
          ),
        );
        Navigator.pop(context);
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
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  InputDecoration _dec(BuildContext context, {String? hint, String? prefixText}) {
    final appColors = context.appColors;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 14,
        color: appColors.secondaryLabel,
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

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final appColors = context.appColors;
    final labelStyle = TextStyle(
      fontFamily: 'Epilogue',
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: context.colorScheme.primary,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: appColors.cardSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: appColors.sheetHandle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    t.goals.contribution.add_title,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: appColors.primaryText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.goals.contribution.amount, style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        autofocus: true,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [CurrencyInputFormatter()],
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 14,
                          color: appColors.primaryText,
                        ),
                        decoration: _dec(context, prefixText: '${widget.currency.symbol}  '),
                        validator: (v) {
                          if (v == null || v.isEmpty) return t.goals.contribution.amount_required;
                          if (double.tryParse(v.replaceAll(',', '')) == null) return t.goals.contribution.amount_invalid;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(t.goals.contribution.date, style: labelStyle),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickDate,
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
                                DateFormat('MMM d, yyyy').format(_selectedDate),
                                style: TextStyle(
                                  fontFamily: 'Epilogue',
                                  fontSize: 14,
                                  color: appColors.primaryText,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: appColors.secondaryLabel,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(t.goals.contribution.note, style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _noteController,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 14,
                          color: appColors.primaryText,
                        ),
                        decoration: _dec(context, hint: t.goals.contribution.note_hint),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
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
                                  t.goals.contribution.save_button,
                                  style: const TextStyle(
                                    fontFamily: 'Epilogue',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
