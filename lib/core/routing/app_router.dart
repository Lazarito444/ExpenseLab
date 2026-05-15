import 'package:expenselab/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  initialLocation: '/accounts',
  routes: [
    GoRoute(
      path: '/accounts',
      builder: (context, state) => const AccountsScreen(),
    ),
  ],
);
