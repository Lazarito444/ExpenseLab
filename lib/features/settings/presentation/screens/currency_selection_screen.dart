import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencySelectionScreen extends ConsumerWidget {
  const CurrencySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Translations t = context.t;
    final appColors = context.appColors;
    final currentCode = ref.watch(currencyProvider).code;

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.settings.default_currency.title,
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: appColors.primaryText,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: appColors.primaryText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: kSupportedCurrencies.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            thickness: 1,
            color: appColors.inputBorder,
            indent: 56,
          ),
          itemBuilder: (context, i) {
            final cur = kSupportedCurrencies[i];
            final isSelected = cur.code == currentCode;

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    cur.symbol,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              title: Text(
                '${cur.code} · ${cur.name}',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                  color: isSelected ? context.colorScheme.primary : appColors.primaryText,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_circle_rounded, color: context.colorScheme.primary, size: 20)
                  : Icon(Icons.circle_outlined, color: appColors.secondaryLabel, size: 20),
              onTap: () {
                ref.read(settingsProvider.notifier).setCurrency(cur);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
