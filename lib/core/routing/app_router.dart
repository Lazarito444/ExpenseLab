import 'package:expenselab/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:expenselab/features/accounts/presentation/screens/create_account_screen.dart';
import 'package:expenselab/features/accounts/presentation/screens/edit_account_screen.dart';
import 'package:expenselab/features/budgets/presentation/screens/budgets_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/categories_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/category_details_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/create_category_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/edit_category_screen.dart';
import 'package:expenselab/features/savings/presentation/screens/goals_screen.dart';
import 'package:expenselab/features/settings/presentation/screens/settings_screen.dart';
import 'package:expenselab/widgets/scaffold/main_scaffold.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const BudgetsScreen(),
        ),
        GoRoute(
          path: '/budgets',
          builder: (context, state) => const BudgetsScreen(),
        ),
        GoRoute(
          path: '/goals',
          builder: (context, state) => const GoalsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/add-transaction',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/accounts',
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
      path: '/categories',
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
