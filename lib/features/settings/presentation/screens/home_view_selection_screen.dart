import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewSelectionScreen extends ConsumerWidget {
  const HomeViewSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Translations t = context.t;
    final bool isCalendar = ref.watch(settingsProvider).value?.defaultHomeIsCalendar ?? false;

    final options = [
      (
        isCalendar: false,
        label: t.settings.default_home_view.dashboard,
        icon: Icons.analytics_outlined,
      ),
      (
        isCalendar: true,
        label: t.settings.default_home_view.calendar,
        icon: Icons.calendar_month_outlined,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.settings.default_home_view.title,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: buildSettingsCard(
            isDark,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.indexed.map((entry) {
                final index = entry.$1;
                final opt = entry.$2;
                final selected = opt.isCalendar == isCalendar;
                final isLast = index == options.length - 1;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildOptionTile(
                      context: context,
                      ref: ref,
                      label: opt.label,
                      icon: opt.icon,
                      isSelected: selected,
                      isDark: isDark,
                      onTap: () {
                        ref.read(settingsProvider.notifier).setDefaultHomeView(opt.isCalendar);
                        Navigator.pop(context);
                      },
                    ),
                    if (!isLast) buildDivider(isDark),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
