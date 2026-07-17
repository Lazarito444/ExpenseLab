import 'package:expenselab/core/database/app_database.dart';

class ReportModel {
  const ReportModel({
    required this.id,
    required this.year,
    required this.month,
    required this.generatedAt,
  });

  final String id;
  final int year;
  final int month;
  final DateTime generatedAt;

  factory ReportModel.fromReport(Report report) => ReportModel(
    id: report.id,
    year: report.year,
    month: report.month,
    generatedAt: report.generatedAt,
  );
}
