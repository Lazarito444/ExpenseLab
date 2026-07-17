import 'dart:io';

import 'package:expenselab/features/reports/domain/services/report_generator_service.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ReportPdfService {
  Future<void> generateAndShare({
    required ReportData data,
    required String reportTitle,
    required String monthName,
    required Currency currency,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              reportTitle,
              style: const pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          ),
          pw.Paragraph(
            text: 'Generated for $monthName',
            style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 12),
          pw.Paragraph(
            text: 'Total Income: ${currency.format(data.totalIncome)}',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Paragraph(
            text: 'Total Expenses: ${currency.format(data.totalExpense)}',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Paragraph(
            text: 'Net Income: ${data.netIncome >= 0 ? '+' : ''}${currency.format(data.netIncome.abs())}',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Paragraph(
            text: 'Savings Rate: ${(data.savingsRate * 100).toStringAsFixed(0)}%',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 24),
          pw.Header(level: 1, text: 'Category Breakdown'),
          if (data.categoryBreakdowns.isEmpty)
            pw.Paragraph(text: 'No transactions for this period.')
          else
            pw.TableHelper.fromTextArray(
              headerStyle: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              cellStyle: const pw.TextStyle(fontSize: 11),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              cellAlignments: const {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
              headers: const ['Type', 'Category', 'Amount', '% vs Last Month'],
              data: data.categoryBreakdowns.map((c) => [
                c.isIncome ? 'income' : 'expense',
                c.categoryName,
                '${currency.format(c.amount)} ${c.isIncome ? 'earned' : 'spent'}',
                c.percentChange != null
                    ? '${c.percentChange! >= 0 ? '+' : ''}${c.percentChange!.toStringAsFixed(0)}%'
                    : '-',
              ]).toList(),
            ),
          pw.SizedBox(height: 24),
          if (data.budgets.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Budgets'),
            pw.TableHelper.fromTextArray(
              headerStyle: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              cellStyle: const pw.TextStyle(fontSize: 11),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              cellAlignments: const {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
              headers: const ['Category', 'Budget', 'Spent', 'Used'],
              data: data.budgets.map((b) => [
                b.categoryName,
                currency.format(b.budgetAmount),
                currency.format(b.spentAmount),
                '${b.percentageUsed.toStringAsFixed(0)}%',
              ]).toList(),
            ),
            pw.SizedBox(height: 24),
          ],
          if (data.savingsGoals.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Savings Goals'),
            pw.TableHelper.fromTextArray(
              headerStyle: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              cellStyle: const pw.TextStyle(fontSize: 11),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              cellAlignments: const {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
              headers: const ['Goal', 'Saved', 'Target', 'Progress'],
              data: data.savingsGoals.map((g) => [
                g.goalName,
                currency.format(g.savedAmount),
                currency.format(g.targetAmount),
                '${g.percentageSaved.toStringAsFixed(0)}%',
              ]).toList(),
            ),
          ],
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final fileName = '${reportTitle.replaceAll(' ', '_')}.pdf';
    final file = File('${dir.path}$fileName');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: reportTitle,
      text: reportTitle,
    );
  }
}
