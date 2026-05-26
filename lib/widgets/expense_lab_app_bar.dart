import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  child: Icon(
                    Icons.account_balance_outlined,
                  ),
                ),
          ),
        ),
      ),
      actions: actions,
      title: Text(title ?? t.app.name, style: context.textTheme.titleMedium),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
