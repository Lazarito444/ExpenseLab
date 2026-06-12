import 'package:drift/drift.dart' as drift;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/exchange_rates/domain/models/exchange_rate_model.dart';
import 'package:expenselab/features/exchange_rates/providers/exchange_rates_providers.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddEditExchangeRateScreen extends ConsumerWidget {
  const AddEditExchangeRateScreen({this.rateId, super.key});

  final String? rateId;

  bool get isEditing => rateId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isEditing) {
      return const _Form(existing: null);
    }

    final rates = ref.watch(exchangeRateModelsProvider);
    final existing = rates.where((r) => r.id == rateId).firstOrNull;

    if (existing == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _Form(existing: existing);
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({required this.existing});

  final ExchangeRateModel? existing;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  final _rateController = TextEditingController();
  String _fromCode = 'USD';
  String _toCode = 'EUR';
  late DateTime _date;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _fromCode = widget.existing!.fromCurrencyCode;
      _toCode = widget.existing!.toCurrencyCode;
      _rateController.text = widget.existing!.rate.toString();
      _date = widget.existing!.date;
    } else {
      _date = DateTime.now();
    }
  }

  @override
  void dispose() {
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = context.t;
    final rate = double.tryParse(_rateController.text.replaceAll(',', ''));
    if (rate == null || rate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.exchange_rates.error_rate_invalid)),
      );
      return;
    }
    if (_fromCode == _toCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.exchange_rates.error_same_currency)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(exchangeRatesRepositoryProvider);
      final dateUtc =
          DateTime.utc(_date.year, _date.month, _date.day);
      final companion = ExchangeRatesCompanion(
        fromCurrencyCode: drift.Value(_fromCode),
        toCurrencyCode: drift.Value(_toCode),
        rate: drift.Value(rate),
        date: drift.Value(dateUtc),
      );

      if (widget.existing != null) {
        await repo.update(widget.existing!.id, companion);
      } else {
        await repo.create(companion);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existing != null
                ? context.t.exchange_rates.success_update
                : context.t.exchange_rates.success_add),
            backgroundColor: const Color(0xFF2D6831),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final t = ctx.t;
        return AlertDialog(
          title: Text(t.exchange_rates.delete_title),
          content: Text(t.exchange_rates.delete_message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.common.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t.common.delete, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(exchangeRatesRepositoryProvider)
          .delete(widget.existing!.id);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _showCurrencySheet(BuildContext context, bool isFrom) {
    final appColors = context.appColors;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: appColors.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, sc) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              _SheetHandle(),
              const SizedBox(height: 16),
              Text(
                isFrom ? context.t.exchange_rates.from_currency : context.t.exchange_rates.to_currency,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: appColors.primaryText,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  controller: sc,
                  itemCount: kSupportedCurrencies.length,
                  itemBuilder: (_, i) {
                    final c = kSupportedCurrencies[i];
                    final selected =
                        isFrom ? c.code == _fromCode : c.code == _toCode;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${c.code} — ${c.name}',
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 14,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selected
                              ? context.colorScheme.primary
                              : appColors.primaryText,
                        ),
                      ),
                      trailing: selected
                          ? Icon(Icons.check_rounded,
                              color: context.colorScheme.primary)
                          : null,
                      onTap: () {
                        setState(() {
                          if (isFrom) {
                            _fromCode = c.code;
                          } else {
                            _toCode = c.code;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final appColors = context.appColors;
    final dateLabel =
        DateFormat('MMM d, yyyy').format(_date.toLocal());
    final isEditing = widget.existing != null;

    return Scaffold(
      backgroundColor: appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: isEditing ? t.exchange_rates.edit_title : t.exchange_rates.add_title,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.colorScheme.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel(label: t.exchange_rates.from_currency),
                        const SizedBox(height: 8),
                        _SelectorField(
                          label: _fromCode,
                          onTap: () => _showCurrencySheet(context, true),
                        ),
                        const SizedBox(height: 16),

                        _FieldLabel(label: t.exchange_rates.to_currency),
                        const SizedBox(height: 8),
                        _SelectorField(
                          label: _toCode,
                          onTap: () => _showCurrencySheet(context, false),
                        ),
                        const SizedBox(height: 16),

                        _FieldLabel(label: '1 $_fromCode ='),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _rateController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 14,
                            color: appColors.primaryText,
                          ),
                          decoration: _fieldDecoration(
                            context: context,
                            hint: '0.00',
                            suffixText: _toCode,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _FieldLabel(label: t.exchange_rates.date_label),
                        const SizedBox(height: 8),
                        _SelectorField(
                          label: dateLabel,
                          trailingIcon: Icons.calendar_today_outlined,
                          onTap: _pickDate,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _submit,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 20),
                      label: Text(
                        isEditing ? t.exchange_rates.save_button : t.exchange_rates.add_button,
                        style: const TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                  if (isEditing) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _delete,
                        icon: const Icon(Icons.delete_outline_rounded,
                            size: 20, color: Colors.red),
                        label: Text(
                          t.common.delete,
                          style: const TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

InputDecoration _fieldDecoration({
  required BuildContext context,
  String? hint,
  String? suffixText,
}) {
  final appColors = context.appColors;
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      fontFamily: 'Epilogue',
      color: appColors.secondaryLabel,
      fontSize: 14,
    ),
    suffixText: suffixText,
    suffixStyle: TextStyle(
      fontFamily: 'Epilogue',
      fontSize: 14,
      color: appColors.secondaryLabel,
    ),
    filled: true,
    fillColor: appColors.inputFill,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      borderSide:
          BorderSide(color: context.colorScheme.primary, width: 1.5),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

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

class _SelectorField extends StatelessWidget {
  const _SelectorField({
    required this.label,
    required this.onTap,
    this.trailingIcon = Icons.keyboard_arrow_down_rounded,
  });

  final String label;
  final VoidCallback onTap;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: appColors.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.inputBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  color: appColors.primaryText,
                ),
              ),
            ),
            Icon(
              trailingIcon,
              size: 22,
              color: appColors.secondaryLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
