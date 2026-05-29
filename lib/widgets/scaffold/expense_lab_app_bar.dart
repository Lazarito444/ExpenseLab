import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/home/providers/home_providers.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExpenseLabAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const ExpenseLabAppBar({
    this.title,
    this.leading,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final t = context.t;

    // When no explicit actions are provided and we're on the home route,
    // inject the calendar toggle action automatically.
    List<Widget>? effectiveActions = actions;
    if (actions == null) {
      final location = GoRouterState.of(context).matchedLocation;
      if (location == AppRoutes.home) {
        final isCalendar = ref.watch(homeIsCalendarProvider);
        effectiveActions = [
          IconButton(
            icon: Icon(
              isCalendar ? Icons.analytics_outlined : Icons.calendar_month_outlined,
              color: context.colorScheme.primary,
            ),
            onPressed: () => ref.read(homeIsCalendarProvider.notifier).toggle(),
          ),
        ];
      }
    }

    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF1E2420) : Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: SizedBox(
            height: 42,
            width: 42,
            child:
                leading ??
                const CircleAvatar(
                  child: Icon(Icons.account_balance_outlined),
                ),
          ),
        ),
      ),
      actions: effectiveActions,
      title: Text(title ?? t.app.name, style: context.textTheme.titleMedium),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
