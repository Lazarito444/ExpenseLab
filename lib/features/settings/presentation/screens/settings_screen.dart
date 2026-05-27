import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:expenselab/features/settings/domain/models/app_settings.dart';
import 'package:expenselab/features/settings/presentation/screens/language_selection_screen.dart';
import 'package:expenselab/features/settings/presentation/screens/theme_selection_screen.dart';
import 'package:expenselab/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Translations t = context.t;
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final AsyncValue<AppSettings> settingsAsync = ref.watch(settingsProvider);
    final AppLocale currentLocale = settingsAsync.value?.locale ?? AppLocale.en;

    final String currentThemeLabel = switch (themeMode) {
      ThemeMode.system => t.settings.theme.system,
      ThemeMode.light => t.settings.theme.light,
      ThemeMode.dark => t.settings.theme.dark,
    };

    final String currentLocaleLabel = switch (currentLocale) {
      AppLocale.en => 'English',
      AppLocale.es => 'Español',
    };

    return Scaffold(
      appBar: ExpenseLabAppBar(
        title: t.settings.title,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colorScheme.primary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              buildSectionHeader(t.settings.preferences, context),
              const SizedBox(height: 12),
              buildSettingsCard(
                isDark,
                child: Column(
                  children: [
                    buildNavTile(
                      context: context,
                      label: t.settings.theme.title,
                      currentValue: currentThemeLabel,
                      icon: Icons.dark_mode_outlined,
                      isDark: isDark,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const ThemeSelectionScreen(),
                        ),
                      ),
                    ),
                    buildNavTile(
                      context: context,
                      label: t.settings.language.title,
                      currentValue: currentLocaleLabel,
                      icon: Icons.language_rounded,
                      isDark: isDark,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const LanguageSelectionScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              buildSectionHeader(t.settings.app, context),
              const SizedBox(height: 12),
              buildSettingsCard(
                isDark,
                child: Column(
                  children: [
                    buildNavTile(
                      context: context,
                      label: t.settings.accounts.title,
                      icon: Icons.account_balance_wallet_outlined,
                      isDark: isDark,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const AccountsScreen(),
                        ),
                      ),
                    ),
                    buildNavTile(
                      context: context,
                      label: t.settings.categories.title,
                      icon: Icons.bar_chart_rounded,
                      isDark: isDark,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const LanguageSelectionScreen(),
                        ),
                      ),
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

Widget buildSectionHeader(String title, BuildContext context) {
  return Text(
    title.toUpperCase(),
    style: context.textTheme.displaySmall,
  );
}

Widget buildNavTile({
  required BuildContext context,
  required String label,
  required IconData icon,
  required bool isDark,
  required VoidCallback onTap,
  String? currentValue,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: context.colorScheme.primary,
        size: 20,
      ),
    ),
    title: Text(
      label,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: isDark ? Colors.white : const Color(0xFF1C221E),
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (currentValue != null)
          Text(
            currentValue,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 14,
              color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
            ),
          ),
        const SizedBox(width: 4),
        Icon(
          Icons.chevron_right_rounded,
          color: isDark ? Colors.white24 : const Color(0xFFBDCDBF),
          size: 20,
        ),
      ],
    ),
    onTap: onTap,
  );
}
