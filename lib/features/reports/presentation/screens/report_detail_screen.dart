import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/reports/domain/services/report_pdf_service.dart';
import 'package:expenselab/features/reports/presentation/widgets/report_budgets_section.dart';
import 'package:expenselab/features/reports/presentation/widgets/report_category_row.dart';
import 'package:expenselab/features/reports/presentation/widgets/report_charts_section.dart';
import 'package:expenselab/features/reports/presentation/widgets/report_savings_section.dart';
import 'package:expenselab/features/reports/providers/reports_providers.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReportDetailScreen extends ConsumerWidget {
  const ReportDetailScreen({required this.reportId, super.key});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final reportAsync = ref.watch(reportByIdProvider(reportId));
    final reportDataAsync = ref.watch(reportDataProvider(reportId));
    final currency = ref.watch(currencyProvider);

    final pdfEnabled = reportDataAsync.asData?.value != null &&
        reportAsync.asData?.value != null;

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: t.reports.title,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf_rounded, color: context.colorScheme.primary),
            onPressed: pdfEnabled
                ? () async {
                    final data = reportDataAsync.asData!.value!;
                    final report = reportAsync.asData!.value!;
                    final pdfMonthName = toBeginningOfSentenceCase(
                      DateFormat('MMMM yyyy').format(DateTime(report.year, report.month)),
                    );
                    final service = ReportPdfService();
                    await service.generateAndShare(
                      data: data,
                      reportTitle: 'ExpenseLab Report - $pdfMonthName',
                      monthName: pdfMonthName,
                      currency: currency,
                    );
                  }
                : null,
          ),
        ],
      ),
      body: SafeArea(
        child: reportAsync.when(
          data: (report) {
            if (report == null) {
              return const Center(child: Text('Report not found'));
            }
            final monthName = toBeginningOfSentenceCase(
              DateFormat('MMMM yyyy').format(DateTime(report.year, report.month)),
            );
            return reportDataAsync.when(
              data: (data) {
                if (data == null) {
                  return const Center(child: Text('No data'));
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                  children: [
                    Text(
                      monthName,
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.colorScheme.scrim,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Generated ${DateFormat.yMMMd().format(report.generatedAt.toLocal())}',
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 13,
                        color: context.appColors.secondaryLabel,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildSectionHeader(t.reports.category_breakdown, context),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.appColors.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: data.categoryBreakdowns.map((c) => ReportCategoryRow(breakdown: c)).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildSectionHeader(t.reports.charts, context),
                    const SizedBox(height: 16),
                    ReportChartsSection(
                      data: data,
                      currency: currency,
                      cashFlowLabel: t.analytics.cash_flow,
                      spendingLabel: t.analytics.spending_by_category,
                      incomeLabel: t.analytics.income_by_category,
                      totalLabel: t.analytics.total,
                      netIncomeLabel: t.analytics.net_income,
                      savingsRateLabel: t.home.savings_rate,
                    ),
                    const SizedBox(height: 24),
                    buildSectionHeader(t.reports.savings_goals, context),
                    const SizedBox(height: 16),
                    ReportSavingsSection(savingsGoals: data.savingsGoals),
                    const SizedBox(height: 24),
                    buildSectionHeader(t.reports.budgets, context),
                    const SizedBox(height: 16),
                    ReportBudgetsSection(budgets: data.budgets),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

Widget buildSectionHeader(String title, BuildContext context) {
  return Text(
    title.toUpperCase(),
    style: TextStyle(
      fontFamily: 'Epilogue',
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
      color: context.appColors.secondaryLabel,
    ),
  );
}
