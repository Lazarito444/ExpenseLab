import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ThemeSelectionScreen extends ConsumerWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Translations t = context.t;
    final ThemeMode currentMode = ref.watch(themeModeProvider);

    final List<({ThemeMode mode, String label, IconData icon})> options = [
      (mode: ThemeMode.system, label: t.settings.theme.system, icon: Icons.brightness_auto_outlined),
      (mode: ThemeMode.light, label: t.settings.theme.light, icon: Icons.light_mode_outlined),
      (mode: ThemeMode.dark, label: t.settings.theme.dark, icon: Icons.dark_mode_outlined),
    ];

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: t.settings.theme.title,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: buildSettingsCard(
            context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.indexed.map(
                ((int, ({IconData icon, String label, ThemeMode mode})) entry) {
                  final int index = entry.$1;
                  final ({ThemeMode mode, String label, IconData icon}) option = entry.$2;
                  final bool isSelected = currentMode == option.mode;
                  final bool isLast = index == options.length - 1;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildOptionTile(
                        context: context,
                        ref: ref,
                        label: option.label,
                        icon: option.icon,
                        isSelected: isSelected,
                        onTap: () {
                          ref.read(settingsProvider.notifier).setThemeMode(option.mode);
                          Navigator.pop(context);
                        },
                      ),
                      if (!isLast) buildDivider(context),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
