import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseLabAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const ExpenseLabAppBar({
    required this.title,
    this.leading,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF1E2420) : Colors.white,
      leading: leading,
      actions: actions,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Epilogue',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
