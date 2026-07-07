// features/compare/presentation/widgets/compare_line_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import 'package:crypto_portfolio_tracker/core/utils/number_formatter.dart';
import 'package:crypto_portfolio_tracker/features/compare/domain/entities/compare_result.dart';

class CompareLineChart extends StatelessWidget {
  final CompareResult result;

  const CompareLineChart({super.key, required this.result});

  List<FlSpot> _normalize(List<double> prices) {
    if (prices.isEmpty) return const [];
    final double minP = prices.reduce((a, b) => a < b ? a : b);
    final double maxP = prices.reduce((a, b) => a > b ? a : b);
    final double range = (maxP - minP) == 0 ? 1 : (maxP - minP);

    return List.generate(prices.length, (i) {
      final normalized = (prices[i] - minP) / range;
      return FlSpot(i.toDouble(), normalized);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstPrices = result.first.chartPoints.map((p) => p.price).toList();
    final secondPrices = result.second.chartPoints.map((p) => p.price).toList();

    final firstSpots = _normalize(firstPrices);
    final secondSpots = _normalize(secondPrices);

    if (firstSpots.isEmpty || secondSpots.isEmpty) {
      return const SizedBox.shrink();
    }

    return LineChart(
      LineChartData(
        minY: -0.05,
        maxY: 1.05,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: firstSpots,
            isCurved: true,
            curveSmoothness: 0.15,
            color: AppColors.chartPrimary,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: secondSpots,
            isCurved: true,
            curveSmoothness: 0.15,
            color: AppColors.chartSecondary,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(color: AppColors.textTertiary, strokeWidth: 1),
                FlDotData(
                  getDotPainter: (spot, percent, bar, index) {
                    return FlDotCirclePainter(
                      radius: 5.r,
                      color: bar.color ?? AppColors.accentAmber,
                      strokeWidth: 2,
                      strokeColor: AppColors.bgBase,
                    );
                  },
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.bgElevated,
            tooltipBorderRadius: BorderRadius.circular(AppRadius.chip),
            tooltipBorder: const BorderSide(color: AppColors.glassBorder),
            tooltipPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 10.h,
            ),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final int index = spot.x.toInt();
                final bool isFirstLine = spot.barIndex == 0;

                final double? realPrice = isFirstLine
                    ? (index < firstPrices.length ? firstPrices[index] : null)
                    : (index < secondPrices.length
                          ? secondPrices[index]
                          : null);

                if (realPrice == null) return null;

                final String label = isFirstLine
                    ? result.first.symbol
                    : result.second.symbol;

                return LineTooltipItem(
                  '$label : ${NumberFormatter.formatCurrency(realPrice)}',
                  AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
