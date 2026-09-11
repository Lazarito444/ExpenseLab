import 'package:expenselab/core/ocr/ocr_result.dart';
import 'package:intl/intl.dart';

/// Pure-Dart heuristic parser for receipt OCR text.
///
/// No Flutter dependency — fully unit-testable.
/// Handles EN/ES receipts, both `1,234.56` and `1.234,56` formats.
class OcrParser {
  const OcrParser();

  /// Parse raw concatenated OCR text into structured [OcrResult].
  ///
  /// [rawText] is the full text from ML Kit joined with `\n`.
  /// Optional [referenceDate] is used to validate / clamp date candidates
  /// (defaults to now). Dates outside ±1 year are discarded.
  OcrResult parse(String rawText, {DateTime? referenceDate}) {
    if (rawText.trim().isEmpty) return OcrResult.empty;

    final ref = referenceDate ?? DateTime.now();
    final lines = rawText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final fullText = lines.join('\n');

    // 1. Amount candidates
    final amountCandidates = _extractAmounts(fullText);
    final bestAmount = _pickBestAmount(fullText, lines, amountCandidates);

    // 2. Date candidates
    final dateCandidates = _extractDates(fullText, ref);
    final bestDate = dateCandidates.isNotEmpty ? dateCandidates.first : null;

    // 3. Merchant (first meaningful line)
    final merchant = _extractMerchant(lines);

    // 4. Currency symbol near best amount
    final currencySymbol = _extractCurrencySymbol(fullText, bestAmount);

    // 5. Confidence scoring
    final confidence = _scoreConfidence(
      hasAmount: bestAmount != null,
      hasDate: bestDate != null,
      hasMerchant: merchant != null,
      amountNearKeyword: _hasAmountNearTotalKeyword(fullText),
      candidateCount: amountCandidates.length,
    );

    return OcrResult(
      rawText: rawText,
      bestAmount: bestAmount,
      bestDate: bestDate,
      merchant: merchant,
      currencySymbol: currencySymbol,
      confidence: confidence,
      amountCandidates: amountCandidates,
      dateCandidates: dateCandidates,
    );
  }

  // ── Amount ────────────────────────────────────────────────────────────────

  static final _amountRegex = RegExp(
    r'(\d{1,3}(?:[.,]\d{3})*[.,]\d{2})',
  );

  static final _totalKeywordRegex = RegExp(
    r'\b(total|amount|balance|pay|due|importe|monto)\b',
    caseSensitive: false,
  );

  static final _totalKeywordStrictRegex = RegExp(
    r'\btotal\b',
    caseSensitive: false,
  );

  List<double> _extractAmounts(String text) {
    final matches = _amountRegex.allMatches(text);
    final amounts = <double>[];

    for (final m in matches) {
      final raw = m.group(1)!;
      final parsed = _parseAmountString(raw);
      if (parsed != null && parsed > 0 && parsed < 10000000) {
        amounts.add(parsed);
      }
    }
    return amounts;
  }

  /// Parse string like "1.234,56" or "1,234.56" or "23,45" → double.
  double? _parseAmountString(String raw) {
    // Determine decimal separator: last occurrence of . or ,
    final lastDot = raw.lastIndexOf('.');
    final lastComma = raw.lastIndexOf(',');

    String normalized;
    if (lastDot > lastComma) {
      // Dot is decimal: 1,234.56 → remove commas
      normalized = raw.replaceAll(',', '');
    } else if (lastComma > lastDot) {
      // Comma is decimal: 1.234,56 or 23,45 → remove dots, comma→dot
      normalized = raw.replaceAll('.', '').replaceAll(',', '.');
    } else {
      // No separator or only one type but no decimal — shouldn't happen due to regex requiring \d{2} after
      normalized = raw;
    }
    return double.tryParse(normalized);
  }

  double? _pickBestAmount(String fullText, List<String> lines, List<double> candidates) {
    if (candidates.isEmpty) return null;
    if (candidates.length == 1) return candidates.first;

    // Find lines containing TOTAL keyword — prioritize strict 'total' first
    // to avoid 'Subtotal' matching before 'TOTAL'.
    final strictTotalLines = <String>[];
    final broadTotalLines = <String>[];
    for (final line in lines) {
      if (_totalKeywordStrictRegex.hasMatch(line)) {
        strictTotalLines.add(line);
      } else if (_totalKeywordRegex.hasMatch(line)) {
        broadTotalLines.add(line);
      }
    }

    // Prefer strict total lines first
    for (final linesGroup in [strictTotalLines, broadTotalLines]) {
      if (linesGroup.isNotEmpty) {
        for (final line in linesGroup) {
          final lineAmounts = _extractAmounts(line);
          if (lineAmounts.isNotEmpty) {
            return lineAmounts.reduce((a, b) => a > b ? a : b);
          }
        }
      }
    }

    // Fallback: largest amount (total is usually biggest)
    // Previous bottom-30% heuristic dropped — caused false wins when no total keyword.
    return candidates.reduce((a, b) => a > b ? a : b);
  }

  bool _hasAmountNearTotalKeyword(String text) {
    // Check if amount appears within 20 chars of TOTAL keyword
    final totalIndices = _totalKeywordRegex.allMatches(text).map((m) => m.start).toList();
    if (totalIndices.isEmpty) return false;
    final amountIndices = _amountRegex.allMatches(text).map((m) => m.start).toList();
    for (final t in totalIndices) {
      for (final a in amountIndices) {
        if ((a - t).abs() < 30) return true;
      }
    }
    return false;
  }

  String? _extractCurrencySymbol(String text, double? amount) {
    if (amount == null) return null;
    // Look for currency symbols near amounts
    final currencyRegex = RegExp(r'[$€£¥]');
    final match = currencyRegex.firstMatch(text);
    return match?.group(0);
  }

  // ── Date ──────────────────────────────────────────────────────────────────

  List<DateTime> _extractDates(String text, DateTime ref) {
    final candidates = <DateTime>[];

    // Pattern 1: MM/dd/yyyy or dd/MM/yyyy or MM-dd-yyyy etc (2-4 digit year)
    final slashDateRegex = RegExp(r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})');

    // Pattern 2: MMM dd, yyyy or dd MMM yyyy (e.g. Sep 11, 2026 / 11 Sep 2026)
    final monthNamesEn = 'Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Sept|Oct|Nov|Dec|January|February|March|April|May|June|July|August|September|October|November|December';
    final monthNamesEs = 'ene|feb|mar|abr|may|jun|jul|ago|sep|sept|oct|nov|dic|enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre';
    final textMonthRegex = RegExp(
      r'(?:(\d{1,2})\s+(' + monthNamesEn + r'|' + monthNamesEs + r')\s+(\d{2,4})|(' + monthNamesEn + r'|' + monthNamesEs + r')\s+(\d{1,2})[,\s]+(\d{2,4}))',
      caseSensitive: false,
    );

    // Try slash dates
    for (final m in slashDateRegex.allMatches(text)) {
      final g1 = int.tryParse(m.group(1)!);
      final g2 = int.tryParse(m.group(2)!);
      var g3 = int.tryParse(m.group(3)!);
      if (g1 == null || g2 == null || g3 == null) continue;
      if (g3 < 100) g3 += 2000; // 2-digit year → 20xx

      // Try both interpretations; prefer the one closer to ref date
      final d1 = _tryDate(g3, g1, g2); // g1=month, g2=day (US)
      final d2 = _tryDate(g3, g2, g1); // g1=day, g2=month (ES/LatAm)

      DateTime? best;
      if (d1 != null && d2 != null) {
        // Pick closer to reference date
        final diff1 = (d1.difference(ref).inDays).abs();
        final diff2 = (d2.difference(ref).inDays).abs();
        best = diff1 <= diff2 ? d1 : d2;
      } else {
        best = d1 ?? d2;
      }

      if (best != null && _isPlausibleDate(best, ref)) {
        candidates.add(best);
      }
    }

    // Try textual month dates
    for (final m in textMonthRegex.allMatches(text)) {
      DateTime? parsed;
      try {
        // Try various DateFormat patterns
        final raw = m.group(0)!;
        parsed = _parseTextualDate(raw);
      } catch (_) {}
      if (parsed != null && _isPlausibleDate(parsed, ref)) {
        candidates.add(parsed);
      }
    }

    // Sort by proximity to reference date (closest first)
    candidates.sort((a, b) {
      final da = (a.difference(ref).inDays).abs();
      final db = (b.difference(ref).inDays).abs();
      return da.compareTo(db);
    });

    // Deduplicate
    final seen = <String>{};
    return candidates.where((d) {
      final key = '${d.year}-${d.month}-${d.day}';
      return seen.add(key);
    }).toList();
  }

  DateTime? _tryDate(int year, int month, int day) {
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    try {
      final d = DateTime(year, month, day);
      // Verify no overflow (e.g. Feb 31 → Mar 3)
      if (d.month != month || d.day != day) return null;
      return d;
    } catch (_) {
      return null;
    }
  }

  bool _isPlausibleDate(DateTime d, DateTime ref) {
    final diffDays = (d.difference(ref).inDays).abs();
    return diffDays <= 365; // within 1 year
  }

  DateTime? _parseTextualDate(String raw) {
    final patterns = [
      'MMM dd, yyyy', 'MMM dd yyyy', 'MMMM dd, yyyy', 'MMMM dd yyyy',
      'dd MMM yyyy', 'dd MMMM yyyy', 'dd/MM/yyyy',
      'MMM dd, yy', 'dd MMM yy',
    ];
    for (final p in patterns) {
      try {
        return DateFormat(p, 'en_US').parse(raw);
      } catch (_) {}
      try {
        return DateFormat(p, 'es').parse(raw);
      } catch (_) {}
    }
    return null;
  }

  // ── Merchant ──────────────────────────────────────────────────────────────

  static const _stopwords = {
    'receipt', 'invoice', 'ticket', 'factura', 'boleta', 'recibo',
    'thank you', 'gracias', 'copy', 'original', 'duplicate',
  };

  String? _extractMerchant(List<String> lines) {
    for (final line in lines) {
      final lower = line.toLowerCase().trim();
      if (lower.isEmpty) continue;
      if (lower.length < 2) continue;
      // Skip lines that are clearly not merchant names
      if (_stopwords.any((w) => lower == w || lower.startsWith('$w '))) continue;
      if (RegExp(r'^[\d\s.,$€£¥/-]+$').hasMatch(lower)) continue; // only numbers/symbols
      if (lower.contains('tel') || lower.contains('phone') || lower.contains('www.') || lower.contains('@')) continue;
      // Heuristic: merchant is usually ALL CAPS or Title Case, short
      // Take first qualifying line
      return line.trim();
    }
    return null;
  }

  // ── Confidence ────────────────────────────────────────────────────────────

  double _scoreConfidence({
    required bool hasAmount,
    required bool hasDate,
    required bool hasMerchant,
    required bool amountNearKeyword,
    required int candidateCount,
  }) {
    double score = 0.0;
    if (hasAmount) score += 0.4;
    if (amountNearKeyword) score += 0.25;
    if (hasDate) score += 0.15;
    if (hasMerchant) score += 0.1;
    if (candidateCount == 1 && hasAmount) score += 0.1; // single clear amount = higher confidence
    if (!hasAmount && !hasDate && !hasMerchant) score = 0.0;
    return score.clamp(0.0, 1.0);
  }
}
