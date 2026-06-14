import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/accounts/domain/models/account_model.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/savings/providers/savings_providers.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final appColors = context.appColors;
    final currency = ref.watch(currencyProvider);
    final goalsAsync = ref.watch(savingsGoalsProvider);
    final accountModels = ref.watch(accountModelsProvider);
    final accountMap = {for (final a in accountModels) a.id: a};

    final allContribs = ref
        .watch(savingsContributionsProvider)
        .maybeWhen(data: (c) => c, orElse: () => []);
    final savedByGoalId = <String, double>{};
    for (final c in allContribs) {
      savedByGoalId[c.savingsGoalId] = (savedByGoalId[c.savingsGoalId] ?? 0) + c.amount;
    }

    return Scaffold(
      backgroundColor: appColors.scaffoldBackground,
      floatingActionButton: FloatingActionButton(
        heroTag: 'goals_fab',
        onPressed: () => context.push(AppRoutes.goalsCreate),
        backgroundColor: context.appColors.actionButtonBg,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
      body: goalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (goals) {
          if (goals.isEmpty) return _EmptyState(t: t);

          final totalSaved = goals.fold(0.0, (sum, g) => sum + (savedByGoalId[g.id] ?? 0.0));
          final totalTarget = goals.fold(0.0, (sum, g) => sum + g.targetAmount);
          final overallPct = totalTarget > 0 ? (totalSaved / totalTarget).clamp(0.0, 1.0) : 0.0;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      t.goals.title,
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.goals.subtitle,
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 14,
                        color: appColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              _SummaryCard(
                currency: currency,
                totalSaved: totalSaved,
                overallPct: overallPct,
                t: t,
              ),
              const SizedBox(height: 20),
              ...goals.map((goal) {
                final saved = savedByGoalId[goal.id] ?? 0.0;
                final progress = goal.targetAmount > 0 ? (saved / goal.targetAmount).clamp(0.0, 1.0) : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _GoalCard(
                    goalName: goal.name,
                    savedAmount: saved,
                    targetAmount: goal.targetAmount,
                    progress: progress,
                    currency: currency,
                    accountMap: accountMap,
                    t: t,
                    onViewDetails: () => context.push(AppRoutes.goalDetails(goal.id)),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.t});

  final Translations t;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.savings_outlined, size: 72, color: context.colorScheme.primary.withValues(alpha: 0.4)),
            const SizedBox(height: 20),
            Text(
              t.goals.no_goals,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: appColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              t.goals.no_goals_subtitle,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 14,
                color: appColors.secondaryLabel,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.currency,
    required this.totalSaved,
    required this.overallPct,
    required this.t,
  });

  final Currency currency;
  final double totalSaved;
  final double overallPct;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final pctLabel = t.goals.target_reached.replaceAll('{pct}', (overallPct * 100).toStringAsFixed(0));

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.goals.total_saved,
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
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.trending_up_rounded, size: 16, color: context.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                pctLabel,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: context.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: overallPct,
              minHeight: 8,
              backgroundColor: context.colorScheme.primary.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(context.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Goal card ─────────────────────────────────────────────────────────────────

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goalName,
    required this.savedAmount,
    required this.targetAmount,
    required this.progress,
    required this.currency,
    required this.accountMap,
    required this.t,
    required this.onViewDetails,
  });

  final String goalName;
  final double savedAmount;
  final double targetAmount;
  final double progress;
  final Currency currency;
  final Map<String, AccountModel> accountMap;
  final Translations t;
  final VoidCallback onViewDetails;

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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goalName,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: context.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  t.goals.saved.replaceAll('{amount}', currency.format(savedAmount)),
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.primary,
                  ),
                ),
                Text(
                  t.goals.target.replaceAll('{amount}', currency.format(targetAmount)),
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 12,
                    color: appColors.secondaryLabel,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onViewDetails,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.goals.view_details,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded, size: 14, color: context.colorScheme.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _DonutProgress(progress: progress),
        ],
      ),
    );
  }
}

// ── Donut progress ────────────────────────────────────────────────────────────

class _DonutProgress extends StatelessWidget {
  const _DonutProgress({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 7,
              backgroundColor: context.colorScheme.primary.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(context.colorScheme.primary),
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: context.appColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
