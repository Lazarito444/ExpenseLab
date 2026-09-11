/// Immutable value object returned by [OcrParser] / [OcrService].
///
/// All parsed fields are nullable — OCR may fail to detect any of them.
/// [confidence] is 0.0..1.0 where 0 means nothing detected and 1 means
/// high-confidence total amount + date found near keywords.
class OcrResult {
  const OcrResult({
    required this.rawText,
    this.bestAmount,
    this.bestDate,
    this.merchant,
    this.currencySymbol,
    this.confidence = 0.0,
    this.amountCandidates = const [],
    this.dateCandidates = const [],
  });

  /// Full concatenated text from ML Kit, for debugging / search.
  final String rawText;

  /// Best amount candidate (e.g. TOTAL). Null if none found.
  final double? bestAmount;

  /// Best date candidate. Null if none found.
  final DateTime? bestDate;

  /// Merchant / store name (first meaningful line). Null if not detected.
  final String? merchant;

  /// Currency symbol detected near amount, e.g. "\$", "€".
  final String? currencySymbol;

  /// 0.0 (nothing) .. 1.0 (high confidence).
  final double confidence;

  /// All amount candidates found (for debugging / alt picks).
  final List<double> amountCandidates;

  /// All date candidates found.
  final List<DateTime> dateCandidates;

  /// Empty result (OCR failed or no text).
  static const OcrResult empty = OcrResult(rawText: '');

  bool get isEmpty => rawText.isEmpty && bestAmount == null && bestDate == null && merchant == null;

  bool get hasAmount => bestAmount != null;

  bool get hasDate => bestDate != null;

  bool get hasMerchant => merchant != null && merchant!.isNotEmpty;
}
