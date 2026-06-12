import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/categories_screen.dart';
import 'package:expenselab/features/security/biometric_service.dart';
import 'package:expenselab/features/security/lock_provider.dart';
import 'package:expenselab/features/settings/domain/models/app_settings.dart';
import 'package:expenselab/features/settings/presentation/screens/currency_selection_screen.dart';
import 'package:expenselab/features/settings/presentation/screens/home_view_selection_screen.dart';
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
    final Translations t = context.t;
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final AsyncValue<AppSettings> settingsAsync = ref.watch(settingsProvider);
    final AppLocale currentLocale = settingsAsync.value?.locale ?? AppLocale.en;
    final currency = ref.watch(currencyProvider);
    final bool defaultHomeIsCalendar = settingsAsync.value?.defaultHomeIsCalendar ?? false;
    final bool biometricLogin = settingsAsync.value?.biometricLogin ?? false;

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
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: t.settings.title,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
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
                context,
                child: Column(
                  children: [
                    buildNavTile(
                      context: context,
                      label: t.settings.theme.title,
                      currentValue: currentThemeLabel,
                      icon: Icons.dark_mode_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const ThemeSelectionScreen()),
                      ),
                    ),
                    buildDivider(context),
                    buildNavTile(
                      context: context,
                      label: t.settings.language.title,
                      currentValue: currentLocaleLabel,
                      icon: Icons.language_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const LanguageSelectionScreen()),
                      ),
                    ),
                    buildDivider(context),
                    buildNavTile(
                      context: context,
                      label: t.settings.default_currency.title,
                      currentValue: '${currency.code} (${currency.symbol})',
                      icon: Icons.currency_exchange_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const CurrencySelectionScreen()),
                      ),
                    ),
                    buildDivider(context),
                    buildNavTile(
                      context: context,
                      label: t.settings.default_home_view.title,
                      currentValue: defaultHomeIsCalendar ? t.settings.default_home_view.calendar : t.settings.default_home_view.dashboard,
                      icon: Icons.home_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const HomeViewSelectionScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              buildSectionHeader(t.settings.app, context),
              const SizedBox(height: 12),
              buildSettingsCard(
                context,
                child: Column(
                  children: [
                    buildNavTile(
                      context: context,
                      label: t.analytics.title,
                      icon: Icons.bar_chart_rounded,
                      onTap: () => context.push(AppRoutes.analytics),
                    ),
                    buildDivider(context),
                    buildNavTile(
                      context: context,
                      label: t.settings.accounts.title,
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const AccountsScreen()),
                      ),
                    ),
                    buildDivider(context),
                    buildNavTile(
                      context: context,
                      label: t.settings.categories.title,
                      icon: Icons.bar_chart_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const CategoriesScreen()),
                      ),
                    ),
                    buildDivider(context),
                    buildNavTile(
                      context: context,
                      label: t.exchange_rates.title,
                      icon: Icons.currency_exchange_rounded,
                      onTap: () => context.push(AppRoutes.exchangeRates),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              buildSectionHeader(t.settings.security.title, context),
              const SizedBox(height: 12),
              buildSettingsCard(
                context,
                child: buildToggleTile(
                  context: context,
                  label: t.settings.security.biometric_login.title,
                  subtitle: t.settings.security.biometric_login.subtitle,
                  icon: Icons.fingerprint_rounded,
                  value: biometricLogin,
                  onChanged: (value) => _onBiometricToggle(value, context, ref),
                ),
              ),
              const SizedBox(height: 24),
              buildSectionHeader(t.settings.danger_zone.title, context),
              const SizedBox(height: 12),
              buildSettingsCard(
                context,
                child: buildDangerTile(
                  context: context,
                  label: t.settings.danger_zone.erase_data.title,
                  subtitle: t.settings.danger_zone.erase_data.subtitle,
                  icon: Icons.delete_forever_rounded,
                  onTap: () => _showEraseConfirmation(context, ref, t),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _onBiometricToggle(bool value, BuildContext context, WidgetRef ref) async {
  if (value) {
    final canAuth = await ref.read(biometricServiceProvider).canAuthenticate();
    if (!canAuth) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No biometrics or screen lock set up on this device.')),
        );
      }
      return;
    }
  }
  await ref.read(settingsProvider.notifier).setBiometricLogin(value);
  if (value) {
    ref.read(isLockedProvider.notifier).lock();
  }
}

Future<void> _showEraseConfirmation(BuildContext context, WidgetRef ref, Translations t) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => _EraseConfirmationDialog(t: t),
  );
  if (confirmed == true) {
    await ref.read(settingsProvider.notifier).eraseAllData();
  }
}

class _EraseConfirmationDialog extends StatefulWidget {
  const _EraseConfirmationDialog({required this.t});
  final Translations t;

  @override
  State<_EraseConfirmationDialog> createState() => _EraseConfirmationDialogState();
}

class _EraseConfirmationDialogState extends State<_EraseConfirmationDialog> {
  final _controller = TextEditingController();
  bool _matches = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final matches = _controller.text == 'ExpenseLab';
      if (matches != _matches) setState(() => _matches = matches);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return AlertDialog(
      title: Text(t.settings.danger_zone.erase_data.confirm_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.settings.danger_zone.erase_data.confirm_message),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: t.settings.danger_zone.erase_data.type_to_confirm,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(t.common.cancel),
        ),
        TextButton(
          onPressed: _matches ? () => Navigator.pop(context, true) : null,
          style: TextButton.styleFrom(foregroundColor: const Color(0xFFD9534F)),
          child: Text(t.settings.danger_zone.erase_data.confirm_button),
        ),
      ],
    );
  }
}

Widget buildSectionHeader(String title, BuildContext context) {
  return Text(title.toUpperCase(), style: context.textTheme.displaySmall);
}

Widget buildNavTile({
  required BuildContext context,
  required String label,
  required IconData icon,
  required VoidCallback onTap,
  String? currentValue,
}) {
  final appColors = context.appColors;
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: context.colorScheme.primary, size: 20),
    ),
    title: Text(
      label,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: appColors.primaryText,
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
              color: appColors.secondaryLabel,
            ),
          ),
        const SizedBox(width: 4),
        Icon(Icons.chevron_right_rounded, color: appColors.secondaryLabel, size: 20),
      ],
    ),
    onTap: onTap,
  );
}
