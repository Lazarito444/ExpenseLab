import 'package:expenselab/core/routing/app_shell.dart';
import 'package:expenselab/features/accounts/presentation/screens/account_details_screen.dart';
import 'package:expenselab/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:expenselab/features/accounts/presentation/screens/create_account_screen.dart';
import 'package:expenselab/features/accounts/presentation/screens/edit_account_screen.dart';
import 'package:expenselab/features/budgets/presentation/screens/budgets_screen.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:expenselab/features/categories/presentation/screens/categories_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/create_edit_category_screen.dart';
import 'package:expenselab/features/savings/presentation/screens/goals_screen.dart';
import 'package:expenselab/features/settings/presentation/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  initialLocation: '/accounts',
  routes: [
    // -------------------------------------------------------------------------
    // Shell: persistent nav bar wraps all top-level tab routes
    // -------------------------------------------------------------------------
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/accounts',
          builder: (context, state) => const AccountsScreen(),
        ),
        GoRoute(
          path: '/budgets',
          builder: (context, state) => const BudgetsScreen(),
        ),
        GoRoute(
          path: '/goals',
          builder: (context, state) => const GoalsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // Full-screen routes (no nav bar)
    // -------------------------------------------------------------------------
    GoRoute(
      path: '/accounts/create',
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      path: '/accounts/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AccountDetailsScreen(accountId: id);
      },
    ),
    GoRoute(
      path: '/accounts/edit/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EditAccountScreen(accountId: id);
      },
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/categories/create',
      builder: (context, state) {
        final typeStr = state.uri.queryParameters['type'];
        final parentId = state.uri.queryParameters['parentId'];
        CategoryType? initialType;
        if (typeStr == 'expense') {
          initialType = CategoryType.expense;
        } else if (typeStr == 'income') {
          initialType = CategoryType.income;
        }
        return CreateEditCategoryScreen(
          initialType: initialType,
          initialParentId: parentId,
        );
      },
    ),
    GoRoute(
      path: '/categories/edit/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CreateEditCategoryScreen(categoryId: id);
      },
    ),
  ],
);
