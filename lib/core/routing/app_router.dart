import 'package:expenselab/features/budgets/presentation/screens/budgets_screen.dart';
import 'package:expenselab/features/savings/presentation/screens/goals_screen.dart';
import 'package:expenselab/features/settings/presentation/screens/settings_screen.dart';
import 'package:expenselab/widgets/scaffold/main_scaffold.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  initialLocation: '/accounts',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/accounts',
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
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
