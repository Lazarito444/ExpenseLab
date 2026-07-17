import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/reports/domain/models/report_model.dart';
import 'package:expenselab/features/reports/providers/reports_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReportsListScreen extends ConsumerWidget {
  const ReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final reportsAsync = ref.watch(reportsProvider);

    ref.watch(ensureLastMonthReportProvider);

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: t.reports.title,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: reportsAsync.when(
          data: (reports) {
            if (reports.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.description_outlined, size: 64, color: context.colorScheme.outline),
                    const SizedBox(height: 16),
                    Text(
                      t.reports.no_reports,
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 16,
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              );
            }
            final sorted = List<ReportModel>.from(reports)
              ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              itemCount: sorted.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final report = sorted[index];
                final monthName = toBeginningOfSentenceCase(
                  DateFormat('MMMM yyyy').format(DateTime(report.year, report.month)),
                );
                final generatedDate = DateFormat.yMMMd().format(report.generatedAt.toLocal());
                return _ReportCard(
                  monthName: monthName,
                  generatedDate: generatedDate,
                  onTap: () => context.push(AppRoutes.reportDetails(report.id)),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('${t.common.error}: $e', style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.monthName,
    required this.generatedDate,
    required this.onTap,
  });

  final String monthName;
  final String generatedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: appColors.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: appColors.inputBorder, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: context.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      monthName,
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.scrim,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      generatedDate,
                      style: TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 13,
                        color: appColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: appColors.secondaryLabel, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
