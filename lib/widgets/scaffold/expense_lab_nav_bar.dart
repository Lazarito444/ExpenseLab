import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExpenseLabNavBar extends StatelessWidget {
  const ExpenseLabNavBar({super.key});

  int _selectedIndex(String location) {
    if (location.startsWith(AppRoutes.budgets)) return 1;
    if (location.startsWith(AppRoutes.goals)) return 3;
    if (location.startsWith(AppRoutes.settings)) return 4;
    return 0;
  }

  static const _tabRoutes = [
    AppRoutes.home,
    AppRoutes.budgets,
    AppRoutes.addTransaction,
    AppRoutes.goals,
    AppRoutes.settings,
  ];

  @override
  Widget build(BuildContext context) {
    const double fabOverflow = 28.0;
    const double navBarHeight = 72.0;

    return SizedBox(
      height: navBarHeight + fabOverflow,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _navBarItems(context),
          _fabButton(context),
        ],
      ),
    );
  }

  Widget _navBarItems(BuildContext context) {
    final t = context.t;
    final location = GoRouterState.of(context).matchedLocation;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex(location),
        indicatorColor: context.colorScheme.primary.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: context.colorScheme.primary,
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            );
          }
          return TextStyle(
            color: Colors.grey.shade700,
            fontFamily: 'Epilogue',
            overflow: TextOverflow.ellipsis,
          );
        }),
        onDestinationSelected: (int index) {
          if (index == 2) return;
          if (index == 4) {
            context.push(AppRoutes.settings);
            return;
          }
          context.go(_tabRoutes[index]);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: t.nav.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: t.nav.budgets,
          ),
          const NavigationDestination(
            icon: SizedBox.shrink(),
            label: "",
          ),
          NavigationDestination(
            icon: const Icon(Icons.savings_outlined),
            label: t.nav.goals,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: t.nav.settings,
          ),
        ],
      ),
    );
  }

  Positioned _fabButton(BuildContext context) {
    return Positioned(
      top: -12,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 56.0,
          height: 56.0,
          child: FloatingActionButton(
            backgroundColor: context.theme.primaryColor,
            onPressed: () {
              context.push(AppRoutes.addTransaction);
            },
            elevation: 4.0,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 28.0),
          ),
        ),
      ),
    );
  }
}
