import 'dart:io';

import 'package:expenselab/core/ocr/ocr_parser.dart';
import 'package:expenselab/core/ocr/ocr_result.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// On-device OCR service using `google_mlkit_text_recognition`.
///
/// No network call. Supports Latin script (EN/ES).
/// Call [recognize] with a local image path, get [OcrResult].
class OcrService {
  OcrService({OcrParser? parser}) : _parser = parser ?? const OcrParser();

  final OcrParser _parser;

  /// Recognize text from [imagePath] and parse it.
  ///
  /// Returns [OcrResult.empty] on failure / no text / timeout.
  /// Timeout 8s as per plan.
  Future<OcrResult> recognize(String imagePath) async {
    if (imagePath.isEmpty) return OcrResult.empty;
    final file = File(imagePath);
    if (!await file.exists()) return OcrResult.empty;

    try {
      final result = await _recognizeInternal(imagePath).timeout(
        const Duration(seconds: 8),
        onTimeout: () => OcrResult.empty,
      );
      return result;
    } catch (e) {
      debugPrint('[OcrService] recognize error: $e');
      return OcrResult.empty;
    }
  }

  Future<OcrResult> _recognizeInternal(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final recognized = await recognizer.processImage(inputImage);
      final rawText = recognized.text;

      if (rawText.trim().isEmpty) {
        return OcrResult.empty;
      }

      // Join blocks/lines for parser (preserves line structure)
      final lines = <String>[];
      for (final block in recognized.blocks) {
        for (final line in block.lines) {
          lines.add(line.text);
        }
      }
      final joined = lines.join('\n');

      return _parser.parse(joined.isEmpty ? rawText : joined);
    } finally {
      await recognizer.close();
    }
  }
}
