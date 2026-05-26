import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSelectionScreen extends ConsumerWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Translations t = context.t;
    final ThemeMode currentMode = ref.watch(themeModeProvider);

    final List<({ThemeMode mode, String label, IconData icon})> options = [
      (mode: ThemeMode.system, label: t.settings.theme.system, icon: Icons.brightness_auto_outlined),
      (mode: ThemeMode.light, label: t.settings.theme.light, icon: Icons.light_mode_outlined),
      (mode: ThemeMode.dark, label: t.settings.theme.dark, icon: Icons.dark_mode_outlined),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.settings.theme.title,
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF0F1E36),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF0F1E36),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: buildSettingsCard(
            isDark,
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
                        isDark: isDark,
                        onTap: () {
                          ref.read(settingsProvider.notifier).setThemeMode(option.mode);
                          Navigator.pop(context);
                        },
                      ),
                      if (!isLast) buildDivider(isDark),
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
