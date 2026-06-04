import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:expenselab/features/accounts/presentation/screens/create_account_screen.dart';
import 'package:expenselab/features/accounts/presentation/screens/edit_account_screen.dart';
import 'package:expenselab/features/budgets/presentation/screens/budgets_screen.dart';
import 'package:expenselab/features/budgets/presentation/screens/create_budget_screen.dart';
import 'package:expenselab/features/budgets/presentation/screens/edit_budget_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/categories_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/category_details_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/create_category_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/edit_category_screen.dart';
import 'package:expenselab/features/home/presentation/screens/home_screen.dart';
import 'package:expenselab/features/savings/presentation/screens/create_goal_screen.dart';
import 'package:expenselab/features/savings/presentation/screens/edit_goal_screen.dart';
import 'package:expenselab/features/savings/presentation/screens/goal_details_screen.dart';
import 'package:expenselab/features/savings/presentation/screens/goals_screen.dart';
import 'package:expenselab/features/settings/presentation/screens/settings_screen.dart';
import 'package:expenselab/features/transactions/presentation/screens/add_transaction_screen.dart';
import 'package:expenselab/widgets/scaffold/main_scaffold.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.budgets,
          builder: (context, state) => const BudgetsScreen(),
        ),
        GoRoute(
          path: AppRoutes.goals,
          builder: (context, state) => const GoalsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.budgetsCreate,
      builder: (context, state) => const CreateBudgetScreen(),
    ),
    GoRoute(
      path: '/budgets/:id/edit',
      builder: (context, state) => EditBudgetScreen(
        budgetId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.goalsCreate,
      builder: (context, state) => const CreateGoalScreen(),
    ),
    GoRoute(
      path: '/goals/:id',
      builder: (context, state) => GoalDetailsScreen(
        goalId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/goals/:id/edit',
      builder: (context, state) => EditGoalScreen(
        goalId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.addTransaction,
      builder: (context, state) {
        final dateStr = state.uri.queryParameters['date'];
        final initialDate = dateStr != null ? DateTime.tryParse(dateStr) : null;
        return AddTransactionScreen(initialDate: initialDate);
      },
    ),
    GoRoute(
      path: '/transactions/:id/edit',
      builder: (context, state) => AddTransactionScreen(
        transactionId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.accounts,
      builder: (context, state) => const AccountsScreen(),
      routes: [
        GoRoute(
          path: 'create',
          builder: (context, state) => const CreateAccountScreen(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) => EditAccountScreen(
            accountId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.categories,
      builder: (context, state) => const CategoriesScreen(),
      routes: [
        GoRoute(
          path: 'create',
          builder: (context, state) => const CreateCategoryScreen(),
        ),
        GoRoute(
          path: ':id/edit',
          builder: (context, state) => EditCategoryScreen(
            categoryId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) => CategoryDetailsScreen(
            categoryId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
);
