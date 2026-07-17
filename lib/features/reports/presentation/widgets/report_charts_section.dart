import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/features/analytics/providers/analytics_providers.dart';
import 'package:expenselab/features/reports/domain/services/report_generator_service.dart';
import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:flutter/material.dart';

class ReportChartsSection extends StatelessWidget {
  const ReportChartsSection({
    required this.data,
    required this.currency,
    required this.cashFlowLabel,
    required this.spendingLabel,
    required this.incomeLabel,
    required this.totalLabel,
    required this.netIncomeLabel,
    required this.savingsRateLabel,
    super.key,
  });

  final ReportData data;
  final Currency currency;
  final String cashFlowLabel;
  final String spendingLabel;
  final String incomeLabel;
  final String totalLabel;
  final String netIncomeLabel;
  final String savingsRateLabel;

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    final appColors = context.appColors;

    return Column(
      children: [
        _buildCashFlowCard(context, primary, appColors),
        const SizedBox(height: 16),
        _buildDonutCard(
          context: context,
          title: spendingLabel,
          total: data.totalExpense,
          shares: data.categoryBreakdowns.where((c) => !c.isIncome).map((c) => CategoryShare(
            name: c.categoryName,
            color: c.color,
            amount: c.amount,
            percentage: c.percentage,
          )).toList(),
          emptyLabel: 'No data',
          totalLabel: totalLabel,
          currency: currency,
        ),
        const SizedBox(height: 16),
        _buildDonutCard(
          context: context,
          title: incomeLabel,
          total: data.totalIncome,
          shares: data.categoryBreakdowns.where((c) => c.isIncome).map((c) => CategoryShare(
            name: c.categoryName,
            color: c.color,
            amount: c.amount,
            percentage: c.percentage,
          )).toList(),
          emptyLabel: 'No data',
          totalLabel: totalLabel,
          currency: currency,
        ),
      ],
    );
  }

  Widget _buildCashFlowCard(BuildContext context, Color primary, dynamic appColors) {
    final points = List.generate(4, (i) => CashFlowPoint(
      label: 'W${i + 1}',
      income: data.cashFlowWeeklyIncome[i],
      expense: data.cashFlowWeeklyExpense[i],
    ));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cashFlowLabel,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.scrim,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: _CashFlowPainter(
                points: points,
                incomeColor: primary,
                expenseColor: primary.withValues(alpha: 0.45),
                labelColor: context.colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatBlock(
                  label: netIncomeLabel,
                  value: '${data.netIncome >= 0 ? '+' : ''}${currency.format(data.netIncome.abs())}',
                  valueColor: data.netIncome >= 0 ? appColors.incomeColor : appColors.expenseColor,
                ),
              ),
              Expanded(
                child: _StatBlock(
                  label: savingsRateLabel,
                  value: '${(data.savingsRate * 100).toStringAsFixed(0)}%',
                  valueColor: context.colorScheme.scrim,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonutCard({
    required BuildContext context,
    required String title,
    required double total,
    required List<CategoryShare> shares,
    required String emptyLabel,
    required String totalLabel,
    required Currency currency,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.scrim,
            ),
          ),
          const SizedBox(height: 20),
          if (shares.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  emptyLabel,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 14,
                    color: context.colorScheme.outline,
                  ),
                ),
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        painter: _DonutPainter(
                          shares: shares,
                          emptyColor: context.colorScheme.primary.withValues(alpha: 0.08),
                        ),
                        size: const Size(130, 130),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _compactTotal(total, currency),
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.scrim,
                            ),
                          ),
                          Text(
                            totalLabel,
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 10,
                              color: context.appColors.secondaryLabel,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: shares.take(5).map((s) => _CategoryLegendRow(share: s)).toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _compactTotal(double amount, Currency currency) {
    if (amount >= 1000000) {
      final m = amount / 1000000;
      return '${currency.symbol}${m % 1 == 0 ? m.toInt() : m.toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      final k = amount / 1000;
      return '${currency.symbol}${k % 1 == 0 ? k.toInt() : k.toStringAsFixed(1)}k';
    }
    return currency.format(amount);
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value, required this.valueColor});

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: context.appColors.secondaryLabel,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _CategoryLegendRow extends StatelessWidget {
  const _CategoryLegendRow({required this.share});

  final CategoryShare share;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: share.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              share.name,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 13,
                color: context.colorScheme.scrim,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${(share.percentage * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: share.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CashFlowPainter extends CustomPainter {
  const _CashFlowPainter({
    required this.points,
    required this.incomeColor,
    required this.expenseColor,
    required this.labelColor,
  });

  final List<CashFlowPoint> points;
  final Color incomeColor;
  final Color expenseColor;
  final Color labelColor;

  static const _labelH = 20.0;
  static const _topPad = 8.0;
  static const _xPad = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    final n = points.length;
    if (n == 0) return;

    final chartBottom = size.height - _labelH;
    const chartTop = _topPad;
    final usableH = chartBottom - chartTop;
    final availW = size.width - 2 * _xPad;

    final maxVal = points.fold(
      0.0,
      (m, p) => math.max(m, math.max(p.income, p.expense)),
    );

    double xFor(int i) => _xPad + i * availW / math.max(n - 1, 1);
    double yFor(double v) {
      if (maxVal == 0) return chartBottom;
      return chartTop + usableH * (1 - (v / maxVal).clamp(0.0, 1.0) * 0.88);
    }

    final incomePos = List.generate(n, (i) => Offset(xFor(i), yFor(points[i].income)));
    final expensePos = List.generate(n, (i) => Offset(xFor(i), yFor(points[i].expense)));

    final fillPath = _smoothPath(incomePos)
      ..lineTo(incomePos.last.dx, chartBottom)
      ..lineTo(incomePos.first.dx, chartBottom)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            incomeColor.withValues(alpha: 0.22),
            incomeColor.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, chartTop, size.width, usableH))
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      _smoothPath(incomePos),
      Paint()
        ..color = incomeColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    _drawDashedPolyline(canvas, expensePos, expenseColor);

    if (n > 0) {
      final last = incomePos.last;
      canvas.drawCircle(last, 5.5, Paint()..color = incomeColor);
      canvas.drawCircle(last, 3.0, Paint()..color = Colors.white);
    }

    final tp = TextPainter(textDirection: ui.TextDirection.ltr);
    for (int i = 0; i < n; i++) {
      tp.text = TextSpan(
        text: points[i].label,
        style: TextStyle(color: labelColor, fontSize: 11, fontFamily: 'Epilogue'),
      );
      tp.layout();
      tp.paint(canvas, Offset(xFor(i) - tp.width / 2, size.height - tp.height));
    }
  }

  Path _smoothPath(List<Offset> pts) {
    final path = Path();
    if (pts.isEmpty) return path;
    path.moveTo(pts[0].dx, pts[0].dy);
    if (pts.length == 1) return path;
    for (int i = 0; i < pts.length - 1; i++) {
      final p0 = pts[i == 0 ? 0 : i - 1];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = pts[i + 2 < pts.length ? i + 2 : pts.length - 1];
      final cp1 = Offset(p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6);
      final cp2 = Offset(p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  void _drawDashedPolyline(Canvas canvas, List<Offset> pts, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < pts.length - 1; i++) {
      _drawDashedSegment(canvas, pts[i], pts[i + 1], paint);
    }
  }

  void _drawDashedSegment(Canvas canvas, Offset start, Offset end, Paint paint, {double dash = 7, double gap = 5}) {
    final d = end - start;
    final len = d.distance;
    if (len == 0) return;
    final unit = d / len;
    double t = 0;
    bool drawing = true;
    while (t < len) {
      final seg = drawing ? dash : gap;
      if (drawing) {
        canvas.drawLine(start + unit * t, start + unit * math.min(t + seg, len), paint);
      }
      t += seg;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(_CashFlowPainter old) => true;
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.shares, required this.emptyColor});

  final List<CategoryShare> shares;
  final Color emptyColor;
  static const double strokeWidth = 18.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2 - 2;

    if (shares.isEmpty) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = emptyColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke,
      );
      return;
    }

    double startAngle = -math.pi / 2;
    const gapAngle = 0.06;

    for (final share in shares) {
      final sweep = share.percentage * 2 * math.pi - gapAngle;
      if (sweep > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle, sweep, false,
          Paint()
            ..color = share.color
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );
      }
      startAngle += share.percentage * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.shares != shares;
}
