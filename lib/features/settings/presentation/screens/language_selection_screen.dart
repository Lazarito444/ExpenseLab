import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Translations t = context.t;
    final AsyncValue<dynamic> settingsAsync = ref.watch(settingsProvider);
    final AppLocale currentLocale = settingsAsync.value?.locale ?? AppLocale.en;

    final List<({AppLocale locale, String label})> options = [
      (locale: AppLocale.en, label: 'English'),
      (locale: AppLocale.es, label: 'Español'),
    ];

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: t.settings.language.title,
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
                ((int, ({AppLocale locale, String label})) entry) {
                  final int index = entry.$1;
                  final ({AppLocale locale, String label}) option = entry.$2;
                  final bool isSelected = currentLocale == option.locale;
                  final bool isLast = index == options.length - 1;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildOptionTile(
                        context: context,
                        ref: ref,
                        label: option.label,
                        isSelected: isSelected,
                        onTap: () {
                          ref.read(settingsProvider.notifier).setLocale(option.locale);
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
