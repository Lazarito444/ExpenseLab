import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/providers/database_providers.dart';
import 'package:expenselab/features/savings/data/datasources/savings_contributions_local_datasource.dart';
import 'package:expenselab/features/savings/data/datasources/savings_contributions_local_datasource_impl.dart';
import 'package:expenselab/features/savings/data/datasources/savings_goals_local_datasource.dart';
import 'package:expenselab/features/savings/data/datasources/savings_goals_local_datasource_impl.dart';
import 'package:expenselab/features/savings/data/repositories/savings_contributions_repository.dart';
import 'package:expenselab/features/savings/data/repositories/savings_goals_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Savings Goals ─────────────────────────────────────────────────────────────

/// Provides [SavingsGoalsLocalDataSourceImpl] bound to the
/// [SavingsGoalsLocalDataSource] interface. Swap the implementation here to
/// change the storage backend without touching any repository or UI code.
final savingsGoalsLocalDataSourceProvider = Provider<SavingsGoalsLocalDataSource>((ref) {
  return SavingsGoalsLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

/// Provides the singleton [SavingsGoalsRepository], wired to
/// [savingsGoalsLocalDataSourceProvider].
final savingsGoalsRepositoryProvider = Provider<SavingsGoalsRepository>((ref) {
  return SavingsGoalsRepository(ref.watch(savingsGoalsLocalDataSourceProvider));
});

/// Streams all non-deleted [SavingsGoal] records. Automatically re-emits
/// whenever the underlying table changes.
///
/// Usage: `ref.watch(savingsGoalsProvider)` returns
/// `AsyncValue<List<SavingsGoal>>`.
final savingsGoalsProvider = StreamProvider<List<SavingsGoal>>((ref) {
  return ref.watch(savingsGoalsRepositoryProvider).watchAll();
});

/// Streams a single [SavingsGoal] by [id], or `null` if not found or
/// soft-deleted. Re-emits whenever the record changes.
final savingsGoalByIdProvider = StreamProvider.family<SavingsGoal?, String>((ref, id) {
  return ref.watch(savingsGoalsRepositoryProvider).watchById(id);
});

// ── Savings Contributions ─────────────────────────────────────────────────────

/// Provides [SavingsContributionsLocalDataSourceImpl] bound to the
/// [SavingsContributionsLocalDataSource] interface. Swap the implementation
/// here to change the storage backend without touching any repository or UI
/// code.
final savingsContributionsLocalDataSourceProvider =
    Provider<SavingsContributionsLocalDataSource>((ref) {
  return SavingsContributionsLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

/// Provides the singleton [SavingsContributionsRepository], wired to
/// [savingsContributionsLocalDataSourceProvider].
final savingsContributionsRepositoryProvider =
    Provider<SavingsContributionsRepository>((ref) {
  return SavingsContributionsRepository(
      ref.watch(savingsContributionsLocalDataSourceProvider));
});

/// Streams all non-deleted [SavingsContribution] records. Automatically
/// re-emits whenever the underlying table changes.
///
/// Usage: `ref.watch(savingsContributionsProvider)` returns
/// `AsyncValue<List<SavingsContribution>>`.
final savingsContributionsProvider = StreamProvider<List<SavingsContribution>>((ref) {
  return ref.watch(savingsContributionsRepositoryProvider).watchAll();
});

/// Streams all non-deleted contributions for [goalId]. Re-emits on every
/// change.
///
/// Usage: `ref.watch(contributionsByGoalProvider('goal-id'))`.
final contributionsByGoalProvider =
    StreamProvider.family<List<SavingsContribution>, String>((ref, goalId) {
  return ref.watch(savingsContributionsRepositoryProvider).watchByGoalId(goalId);
});
