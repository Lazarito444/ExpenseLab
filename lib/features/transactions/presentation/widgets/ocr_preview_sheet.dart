import 'dart:io';

import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/ocr/ocr_result.dart';
import 'package:expenselab/features/categories/domain/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Result returned when user confirms OCR values.
class OcrConfirmedValues {
  const OcrConfirmedValues({
    this.amount,
    this.date,
    this.merchant,
    this.suggestedCategoryId,
  });

  final double? amount;
  final DateTime? date;
  final String? merchant;
  final String? suggestedCategoryId;
}

/// Bottom sheet that shows OCR scan results as suggestion (never auto-fills).
///
/// Chip-only category: shows suggested category chip, requires tap to apply.
class OcrPreviewSheet extends StatefulWidget {
  const OcrPreviewSheet({
    required this.result,
    required this.imagePath,
    this.suggestedCategory,
    super.key,
  });

  final OcrResult result;
  final String imagePath;
  final CategoryModel? suggestedCategory;

  @override
  State<OcrPreviewSheet> createState() => _OcrPreviewSheetState();
}

class _OcrPreviewSheetState extends State<OcrPreviewSheet> {
  late final TextEditingController _amountController;
  late final TextEditingController _merchantController;
  late DateTime? _selectedDate;
  bool _showRawText = false;
  String? _selectedCategoryId; // chip-only: null until user taps
  bool _categoryChipSelected = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.result.bestAmount != null
          ? widget.result.bestAmount!.toStringAsFixed(2)
          : '',
    );
    _merchantController = TextEditingController(text: widget.result.merchant ?? '');
    _selectedDate = widget.result.bestDate;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  double? get _parsedAmount => double.tryParse(_amountController.text.trim());

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final t = context.t.transactions.ocr;
    final ocr = widget.result;
    final isHighConfidence = ocr.confidence >= 0.75;
    final hasNoText = ocr.rawText.trim().isEmpty;

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, sc) => Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    t.review_title,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                if (!hasNoText)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isHighConfidence ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isHighConfidence ? const Color(0xFF4CAF50) : const Color(0xFFFFB300),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isHighConfidence ? Icons.verified_rounded : Icons.warning_amber_rounded,
                          size: 14,
                          color: isHighConfidence ? const Color(0xFF2E7D32) : const Color(0xFFF57F17),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isHighConfidence ? t.confidence_high : t.confidence_review,
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isHighConfidence ? const Color(0xFF2E7D32) : const Color(0xFFF57F17),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              controller: sc,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                // Thumbnail
                if (widget.imagePath.isNotEmpty && File(widget.imagePath).existsSync())
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(widget.imagePath),
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                if (widget.imagePath.isNotEmpty && File(widget.imagePath).existsSync())
                  const SizedBox(height: 16),

                // Empty state
                if (hasNoText) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.errorContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_off_rounded, color: cs.error, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            t.no_text_found,
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: cs.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Amount field
                _SectionLabel(t.amount_label),
                const SizedBox(height: 6),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(fontFamily: 'Epilogue', fontSize: 15, color: cs.onSurface),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.attach_money_rounded, color: cs.primary, size: 18),
                    hintText: '0.00',
                  ),
                ),
                const SizedBox(height: 16),

                // Date field
                _SectionLabel(t.date_label),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && mounted) {
                      if (!context.mounted) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
                      );
                      if (!mounted) return;
                      setState(() {
                        _selectedDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          time?.hour ?? _selectedDate?.hour ?? DateTime.now().hour,
                          time?.minute ?? _selectedDate?.minute ?? DateTime.now().minute,
                        );
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.outline),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, color: cs.primary, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedDate != null
                                ? DateFormat('MMM dd, yyyy HH:mm').format(_selectedDate!)
                                : '—',
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 14,
                              color: _selectedDate != null ? cs.onSurface : cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Icon(Icons.edit_rounded, color: cs.onSurfaceVariant, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Merchant field
                _SectionLabel(t.merchant_label),
                const SizedBox(height: 6),
                TextField(
                  controller: _merchantController,
                  style: TextStyle(fontFamily: 'Epilogue', fontSize: 14, color: cs.onSurface),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.store_rounded, color: cs.primary, size: 18),
                    hintText: t.merchant_label,
                  ),
                ),
                const SizedBox(height: 16),

                // Suggested category chip (chip-only: requires tap)
                if (widget.suggestedCategory != null) ...[
                  _SectionLabel(t.suggested_category),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilterChip(
                      label: Text(
                        widget.suggestedCategory!.name,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 13,
                          fontWeight: _categoryChipSelected ? FontWeight.w600 : FontWeight.w400,
                          color: _categoryChipSelected ? Colors.white : cs.onSurface,
                        ),
                      ),
                      avatar: Icon(
                        Icons.category_rounded,
                        size: 16,
                        color: _categoryChipSelected ? Colors.white : widget.suggestedCategory!.color,
                      ),
                      selected: _categoryChipSelected,
                      selectedColor: cs.primary,
                      backgroundColor: cs.surfaceContainerHighest,
                      onSelected: (v) => setState(() {
                        _categoryChipSelected = v;
                        _selectedCategoryId = v ? widget.suggestedCategory!.id : null;
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Low confidence hint
                if (!isHighConfidence && !hasNoText) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFFB300).withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFF57F17)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            t.low_confidence,
                            style: const TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 12,
                              color: Color(0xFFF57F17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Raw text collapsible
                if (ocr.rawText.isNotEmpty) ...[
                  InkWell(
                    onTap: () => setState(() => _showRawText = !_showRawText),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            t.raw_text_label,
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: cs.primary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            _showRawText ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                            size: 16,
                            color: cs.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showRawText)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ocr.rawText,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 11,
                          color: cs.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          t.retake,
                          style: const TextStyle(fontFamily: 'Epilogue', fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            OcrConfirmedValues(
                              amount: _parsedAmount,
                              date: _selectedDate,
                              merchant: _merchantController.text.trim().isEmpty ? null : _merchantController.text.trim(),
                              suggestedCategoryId: _selectedCategoryId,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          t.use_values,
                          style: const TextStyle(fontFamily: 'Epilogue', fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: cs.primary,
        letterSpacing: 1.2,
      ),
    );
  }
}
