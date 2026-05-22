import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = context.t;
    final themeMode = ref.watch(themeModeProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final currentLocale = settingsAsync.value?.locale ?? AppLocale.en;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.settings.title,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  color: isDark ? Colors.white : const Color(0xFF0F1E36),
                ),
              ),
              const SizedBox(height: 24),

              // Theme Section
              _buildSectionHeader(t.settings.theme.title, isDark),
              const SizedBox(height: 12),
              _buildSettingsCard(
                isDark,
                child: Column(
                  children: [
                    _buildThemeTile(context, ref, t.settings.theme.system, ThemeMode.system, themeMode, Icons.brightness_auto_outlined, isDark),
                    _buildDivider(isDark),
                    _buildThemeTile(context, ref, t.settings.theme.light, ThemeMode.light, themeMode, Icons.light_mode_outlined, isDark),
                    _buildDivider(isDark),
                    _buildThemeTile(context, ref, t.settings.theme.dark, ThemeMode.dark, themeMode, Icons.dark_mode_outlined, isDark),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Language Section
              _buildSectionHeader(t.settings.language.title, isDark),
              const SizedBox(height: 12),
              _buildSettingsCard(
                isDark,
                child: Column(
                  children: [
                    _buildLocaleTile(context, ref, 'English', AppLocale.en, currentLocale, isDark),
                    _buildDivider(isDark),
                    _buildLocaleTile(context, ref, 'Español', AppLocale.es, currentLocale, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1.2,
        color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
      ),
    );
  }

  Widget _buildSettingsCard(bool isDark, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2420) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
      indent: 56,
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    WidgetRef ref,
    String label,
    ThemeMode mode,
    ThemeMode currentMode,
    IconData icon,
    bool isDark,
  ) {
    final isSelected = currentMode == mode;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? context.colorScheme.primary : (isDark ? Colors.white54 : const Color(0xFF5D6B60)),
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Epilogue',
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? context.colorScheme.primary : (isDark ? Colors.white : const Color(0xFF1C221E)),
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: context.colorScheme.primary, size: 20)
          : null,
      onTap: () => ref.read(settingsProvider.notifier).setThemeMode(mode),
    );
  }

  Widget _buildLocaleTile(
    BuildContext context,
    WidgetRef ref,
    String label,
    AppLocale locale,
    AppLocale currentLocale,
    bool isDark,
  ) {
    final isSelected = currentLocale == locale;
    return ListTile(
      leading: Icon(
        Icons.language_rounded,
        color: isSelected ? context.colorScheme.primary : (isDark ? Colors.white54 : const Color(0xFF5D6B60)),
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Epilogue',
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? context.colorScheme.primary : (isDark ? Colors.white : const Color(0xFF1C221E)),
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: context.colorScheme.primary, size: 20)
          : null,
      onTap: () => ref.read(settingsProvider.notifier).setLocale(locale),
    );
  }
}
