import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:flutter/material.dart';

class CreditCardFieldsSection extends StatelessWidget {
  const CreditCardFieldsSection({
    required this.creditLimitController,
    required this.aprController,
    required this.minPaymentController,
    required this.rewardRateController,
    required this.statementDay,
    required this.dueDay,
    required this.minPaymentType,
    required this.rewardType,
    required this.onStatementDayChanged,
    required this.onDueDayChanged,
    required this.onMinPaymentTypeChanged,
    required this.onRewardTypeChanged,
    required this.currency,
    required this.t,
    super.key,
  });

  final TextEditingController creditLimitController;
  final TextEditingController aprController;
  final TextEditingController minPaymentController;
  final TextEditingController rewardRateController;
  final int? statementDay;
  final int? dueDay;
  final String minPaymentType;
  final String rewardType;
  final ValueChanged<int?> onStatementDayChanged;
  final ValueChanged<int?> onDueDayChanged;
  final ValueChanged<String> onMinPaymentTypeChanged;
  final ValueChanged<String> onRewardTypeChanged;
  final Currency currency;
  final Translations t;

  static const _appFontFamily = 'Epilogue';

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DividerWithLabel(label: t.accounts.credit_card_fields.header),
        const SizedBox(height: 16),

        // Credit Limit
        _SectionLabel(label: t.accounts.credit_card_fields.credit_limit),
        const SizedBox(height: 10),
        TextFormField(
          controller: creditLimitController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            fontFamily: _appFontFamily,
            fontSize: 14,
            color: appColors.primaryText,
          ),
          decoration: _fieldDecoration(context,
            hint: '0.00',
            prefix: Text(
              '${currency.symbol}  ',
              style: TextStyle(
                fontFamily: _appFontFamily,
                fontSize: 14,
                color: appColors.primaryText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),

        // Statement Day & Due Day
        Row(
          children: [
            Expanded(
              child: _DaySelector(
                label: t.accounts.credit_card_fields.statement_day,
                value: statementDay,
                onChanged: onStatementDayChanged,
                t: t,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DaySelector(
                label: t.accounts.credit_card_fields.due_day,
                value: dueDay,
                onChanged: onDueDayChanged,
                t: t,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),

        // APR
        _SectionLabel(label: t.accounts.credit_card_fields.apr),
        const SizedBox(height: 10),
        TextFormField(
          controller: aprController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            fontFamily: _appFontFamily,
            fontSize: 14,
            color: appColors.primaryText,
          ),
          decoration: _fieldDecoration(context,
            hint: 'e.g. 24.99',
            suffix: Text(
              ' %',
              style: TextStyle(
                fontFamily: _appFontFamily,
                fontSize: 14,
                color: appColors.secondaryLabel,
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),

        // Minimum Payment
        _SectionLabel(label: t.accounts.credit_card_fields.minimum_payment),
        const SizedBox(height: 10),
        Row(
          children: [
            _ToggleChip(
              label: t.accounts.credit_card_fields.min_percent,
              selected: minPaymentType == 'percent',
              onTap: () => onMinPaymentTypeChanged('percent'),
            ),
            const SizedBox(width: 8),
            _ToggleChip(
              label: t.accounts.credit_card_fields.min_fixed,
              selected: minPaymentType == 'fixed',
              onTap: () => onMinPaymentTypeChanged('fixed'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: minPaymentController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            fontFamily: _appFontFamily,
            fontSize: 14,
            color: appColors.primaryText,
          ),
          decoration: _fieldDecoration(context,
            hint: minPaymentType == 'percent' ? 'e.g. 2' : '0.00',
            prefix: Text(
              minPaymentType == 'percent' ? '  %  ' : '${currency.symbol}  ',
              style: TextStyle(
                fontFamily: _appFontFamily,
                fontSize: 14,
                color: appColors.primaryText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),

        // Rewards
        _SectionLabel(label: t.accounts.credit_card_fields.rewards_type),
        const SizedBox(height: 10),
        _RewardTypeSelector(
          value: rewardType,
          onChanged: onRewardTypeChanged,
          t: t,
        ),
        if (rewardType != 'none') ...[
          const SizedBox(height: 22),
          _SectionLabel(label: t.accounts.credit_card_fields.rewards_rate),
          const SizedBox(height: 10),
          TextFormField(
            controller: rewardRateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              fontFamily: _appFontFamily,
              fontSize: 14,
              color: appColors.primaryText,
            ),
            decoration: _fieldDecoration(context,
              hint: rewardType == 'cashback' ? 'e.g. 0.02' : 'e.g. 1',
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    String? hint,
    Widget? prefix,
    Widget? suffix,
  }) {
    final appColors = context.appColors;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: _appFontFamily,
        color: appColors.secondaryLabel,
        fontSize: 14,
      ),
      prefix: prefix,
      suffix: suffix,
      filled: true,
      fillColor: appColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.colorScheme.primary, width: 1.5),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────

class _DaySelector extends StatelessWidget {
  const _DaySelector({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.t,
  });

  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return GestureDetector(
      onTap: () => _showDayPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: appColors.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.inputBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 11,
                      color: appColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value != null ? 'Day ${value!}' : '--',
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 14,
                      color: appColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: appColors.secondaryLabel,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  void _showDayPicker(BuildContext context) {
    final appColors = context.appColors;
    showModalBottomSheet<int>(
      context: context,
      backgroundColor: appColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sheetHandle(context),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: appColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.2,
                ),
                itemCount: 28,
                itemBuilder: (_, i) {
                  final day = i + 1;
                  final isSelected = day == value;
                  return GestureDetector(
                    onTap: () {
                      onChanged(day);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : appColors.primaryText,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? context.colorScheme.primary
              : context.appColors.inputFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? context.colorScheme.primary
                : context.appColors.inputBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : context.appColors.primaryText,
          ),
        ),
      ),
    );
  }
}

class _RewardTypeSelector extends StatelessWidget {
  const _RewardTypeSelector({
    required this.value,
    required this.onChanged,
    required this.t,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    final options = [
      ('none', t.accounts.credit_card_fields.no_rewards),
      ('cashback', t.accounts.credit_card_fields.cashback),
      ('points', t.accounts.credit_card_fields.points),
      ('miles', t.accounts.credit_card_fields.miles),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final (key, label) = opt;
        final isSelected = value == key;
        return _ToggleChip(
          label: label,
          selected: isSelected,
          onTap: () => onChanged(key),
        );
      }).toList(),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: context.colorScheme.primary,
      ),
    );
  }
}

class _DividerWithLabel extends StatelessWidget {
  const _DividerWithLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.appColors.secondaryLabel,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: context.appColors.inputBorder,
          ),
        ),
      ],
    );
  }
}

Widget _sheetHandle(BuildContext context) {
  return Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: context.appColors.sheetHandle,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}
