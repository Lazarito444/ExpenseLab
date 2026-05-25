import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/budgets')) return 1;
    if (location.startsWith('/goals')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
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
    context.push('/accounts/create');
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentIndex(context);
    final t = context.t;

    final List<String> labels = [
      t.nav.home,
      t.nav.budgets,
      t.nav.goals,
      t.nav.settings,
    ];

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: _NavBar(
        currentIndex: current,
        labels: labels,
        destinations: _destinations,
        onTap: (i) => _onTap(context, i),
        onFabTap: () => _onFabTap(context),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.currentIndex,
    required this.labels,
    required this.destinations,
    required this.onTap,
    required this.onFabTap,
  });

  final int currentIndex;
  final List<String> labels;
  final List<_NavDestination> destinations;
  final ValueChanged<int> onTap;
  final VoidCallback onFabTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    const double fabSize = 52;
    // Capturamos el padding del sistema para asegurar que no se solape en dispositivos con notch inferior
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      // Añadimos un margen constante a los lados y abajo para el efecto flotante
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: bottomPadding > 0 ? bottomPadding : 16,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              // Bordes completamente redondeados
              borderRadius: BorderRadius.circular(24),
              // Borde sutil opcional alrededor de todo el contenedor (estilo la segunda imagen)
              border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
              // Añadimos una pequeña sombra para darle el efecto de elevación flotante
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _NavItem(
                        icon: destinations[0].icon,
                        activeIcon: destinations[0].activeIcon,
                        label: labels[0],
                        isActive: currentIndex == 0,
                        onTap: () => onTap(0),
                      ),
                      _NavItem(
                        icon: destinations[1].icon,
                        activeIcon: destinations[1].activeIcon,
                        label: labels[1],
                        isActive: currentIndex == 1,
                        onTap: () => onTap(1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 60),
                Expanded(
                  child: Row(
                    children: [
                      _NavItem(
                        icon: destinations[2].icon,
                        activeIcon: destinations[2].activeIcon,
                        label: labels[2],
                        isActive: currentIndex == 2,
                        onTap: () => onTap(2),
                      ),
                      _NavItem(
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
          Positioned(
            top: -(fabSize / 4),
            left: 0,
            right: 0,
            child: Center(
              child: _FabButton(onTap: onFabTap),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final activeColor = cs.primary;
    final inactiveColor = cs.onSurfaceVariant;

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
            color: isActive ? cs.primary.withValues(alpha: 0.12) : Colors.transparent,
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
                  color: isActive ? activeColor : inactiveColor,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? activeColor : inactiveColor,
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
            colors: [primary, Color.lerp(primary, Colors.white, 0.15)!],
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
