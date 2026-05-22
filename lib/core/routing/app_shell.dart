import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// The persistent app shell that hosts the bottom nav bar.
/// All top-level tab routes are rendered as children via [ShellRoute].
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const List<_NavDestination> _destinations = [
    _NavDestination(
      label: 'home',
      icon: Icons.grid_view_rounded,
      activeIcon: Icons.grid_view_rounded,
      path: '/accounts',
    ),
    _NavDestination(
      label: 'budgets',
      icon: Icons.wallet_outlined,
      activeIcon: Icons.wallet_rounded,
      path: '/budgets',
    ),
    // index 2 is the FAB — no entry here
    _NavDestination(
      label: 'goals',
      icon: Icons.savings_outlined,
      activeIcon: Icons.savings_rounded,
      path: '/goals',
    ),
    _NavDestination(
      label: 'settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      path: '/settings',
    ),
  ];

  /// Maps the current route location to a 0-based tab index (0-3, skipping FAB)
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/budgets')) return 1;
    if (location.startsWith('/goals')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0; // default → Home / Accounts
  }

  void _onTap(BuildContext context, int index) {
    HapticFeedback.lightImpact();
    switch (index) {
      case 0:
        context.go('/accounts');
      case 1:
        context.go('/budgets');
      case 2:
        context.go('/goals');
      case 3:
        context.go('/settings');
    }
  }

  void _onFabTap(BuildContext context) {
    HapticFeedback.mediumImpact();
    // TODO: open a transaction creation sheet
    context.push('/accounts/create');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = _currentIndex(context);
    final t = context.t;

    final List<String> labels = [
      t.nav.home,
      t.nav.budgets,
      t.nav.goals,
      t.nav.settings,
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
      extendBody: true, // lets the page content slide behind the floating bar
      body: child,
      bottomNavigationBar: _FloatingNavBar(
        isDark: isDark,
        currentIndex: current,
        labels: labels,
        destinations: _destinations,
        onTap: (i) => _onTap(context, i),
        onFabTap: () => _onFabTap(context),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Floating nav bar widget
// ---------------------------------------------------------------------------

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.isDark,
    required this.currentIndex,
    required this.labels,
    required this.destinations,
    required this.onTap,
    required this.onFabTap,
  });

  final bool isDark;
  final int currentIndex;
  final List<String> labels;
  final List<_NavDestination> destinations;
  final ValueChanged<int> onTap;
  final VoidCallback onFabTap;

  @override
  Widget build(BuildContext context) {
    // Background + margin to make it "float"
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2420) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left two items
              Expanded(
                child: Row(
                  children: [
                    _NavItem(
                      isDark: isDark,
                      icon: destinations[0].icon,
                      activeIcon: destinations[0].activeIcon,
                      label: labels[0],
                      isActive: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                    _NavItem(
                      isDark: isDark,
                      icon: destinations[1].icon,
                      activeIcon: destinations[1].activeIcon,
                      label: labels[1],
                      isActive: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                  ],
                ),
              ),

              // Center FAB
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _FabButton(onTap: onFabTap),
              ),

              // Right two items
              Expanded(
                child: Row(
                  children: [
                    _NavItem(
                      isDark: isDark,
                      icon: destinations[2].icon,
                      activeIcon: destinations[2].activeIcon,
                      label: labels[2],
                      isActive: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                    _NavItem(
                      isDark: isDark,
                      icon: destinations[3].icon,
                      activeIcon: destinations[3].activeIcon,
                      label: labels[3],
                      isActive: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual nav item
// ---------------------------------------------------------------------------

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.isDark,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final bool isDark;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark
                    ? primary.withValues(alpha: 0.15)
                    : primary.withValues(alpha: 0.09))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? activeIcon : icon,
                  key: ValueKey(isActive),
                  size: 22,
                  color: isActive
                      ? primary
                      : (isDark ? Colors.white38 : const Color(0xFF9EAEA2)),
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? primary
                      : (isDark ? Colors.white38 : const Color(0xFF9EAEA2)),
                ),
                child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Center FAB button
// ---------------------------------------------------------------------------

class _FabButton extends StatelessWidget {
  const _FabButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [primary, const Color(0xFF4C8D5B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: primary.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data class
// ---------------------------------------------------------------------------

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;
}
