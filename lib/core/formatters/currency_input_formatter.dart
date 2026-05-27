import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A [TextInputFormatter] that live-formats a number with thousands separators
/// (commas) and at most two decimal places while the user types.
///
/// Examples of what the field displays as keys are pressed:
///   1          →  1
///   12         →  12
///   123        →  123
///   1234       →  1,234
///   12345.6    →  12,345.6
///   12345.67   →  12,345.67
///   12345.678  →  12,345.67   (3rd decimal digit rejected)
///
/// Commas typed by the user are ignored (stripped before processing).
///
/// Use [formatForDisplay] to format an initial [double] value in the same
/// style before assigning it to the controller.
class CurrencyInputFormatter extends TextInputFormatter {
  static final _intFormat = NumberFormat('#,##0', 'en_US');
  static final _displayFormat = NumberFormat('#,##0.00', 'en_US');

  /// Formats [value] for initial display in the text field.
  ///
  /// ```dart
  /// controller.text = CurrencyInputFormatter.formatForDisplay(1234.56);
  /// // → "1,234.56"
  /// ```
  static String formatForDisplay(double value) => _displayFormat.format(value);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Strip commas that are already part of the formatted display so we work
    // on raw digits + optional decimal separator.
    final raw = newValue.text.replaceAll(',', '');

    // Reject characters other than digits and a single decimal point.
    if (raw.contains(RegExp(r'[^0-9.]'))) return oldValue;

    // Reject a second decimal point.
    if (raw.indexOf('.') != raw.lastIndexOf('.')) return oldValue;

    // Empty field is fine.
    if (raw.isEmpty) return newValue.copyWith(text: '');

    final hasDecimal = raw.contains('.');
    final parts = raw.split('.');
    final intPart = parts[0]; // digits before the decimal point
    final decPart = parts.length > 1
        ? parts[1].substring(0, parts[1].length.clamp(0, 2))
        : '';

    // If the user cleared the integer part (e.g. ".5") prepend a zero.
    final intValue = int.tryParse(intPart.isEmpty ? '0' : intPart) ?? 0;
    final formattedInt =
        intPart.isEmpty ? '' : _intFormat.format(intValue);

    final result = hasDecimal ? '$formattedInt.$decPart' : formattedInt;

    return TextEditingValue(
      text: result,
      // Always keep the cursor at the end; mid-string editing with a
      // live-reformatting formatter would produce confusing cursor jumps.
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
