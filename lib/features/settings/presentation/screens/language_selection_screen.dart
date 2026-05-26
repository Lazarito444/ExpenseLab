import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Translations t = context.t;
    final AsyncValue<dynamic> settingsAsync = ref.watch(settingsProvider);
    final AppLocale currentLocale = settingsAsync.value?.locale ?? AppLocale.en;

    final List<({AppLocale locale, String label})> options = [
      (locale: AppLocale.en, label: 'English'),
      (locale: AppLocale.es, label: 'Español'),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.settings.language.title,
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
                        isDark: isDark,
                        onTap: () {
                          ref.read(settingsProvider.notifier).setLocale(option.locale);
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
