// features/coin_detail/presentation/widgets/coin_detail_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/shared/widgets/glass_shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_formatter.dart';
import '../cubit/coin_detail_cubit.dart';
import '../cubit/coin_detail_state.dart';

class CoinDetailChart extends StatelessWidget {
  const CoinDetailChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDetailCubit, CoinDetailState>(
      buildWhen: (previous, current) =>
          current is CoinDetailLoaded &&
          (previous is! CoinDetailLoaded ||
              previous.isChartLoading != current.isChartLoading ||
              previous.chartPoints != current.chartPoints ||
              previous.coin != current.coin),
      builder: (context, state) {
        if (state is! CoinDetailLoaded) return const SizedBox.shrink();

        return SizedBox(
          height: 220.h,
          child: state.isChartLoading
              ? GlassShimmer(
                  child: ShimmerBlock(
                    width: double.infinity,
                    height: 220.h,
                    borderRadius: 16.r,
                  ),
                )
              : _Chart(
                  coin: state.coin,
                  points: state.chartPoints,
                  spots: state.chartSpots,
                ),
        );
      },
    );
  }
}

class _Chart extends StatelessWidget {
  final dynamic coin;
  final List<dynamic> points;
  final List<FlSpot> spots;

  const _Chart({required this.coin, required this.points, required this.spots});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    final isPositive = coin.priceChangePercentage24h >= 0;
    final lineColor = isPositive ? AppColors.positive : AppColors.negative;

  final prices = spots.map((s) => s.y).toList();
    final rawMinY = prices.reduce((a, b) => a < b ? a : b);
    final rawMaxY = prices.reduce((a, b) => a > b ? a : b);
    final avgPrice = prices.reduce((a, b) => a + b) / prices.length;
    final rawRange = rawMaxY - rawMinY;
    final minVisualRange = avgPrice * 0.005;
    final range = rawRange < minVisualRange ? minVisualRange : rawRange;
    final center = (rawMaxY + rawMinY) / 2;
    final minY = center - range / 2;
    final maxY = center + range / 2;
    final padding = range * 0.1;

    return LineChart(
      LineChartData(
        minY: minY - padding,
        maxY: maxY + padding,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(color: Colors.white, strokeWidth: 1),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) =>
                      FlDotCirclePainter(
                        radius: 5,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: lineColor,
                      ),
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.bgSurfaceSolid,
            tooltipBorder: BorderSide(color: AppColors.bgElevatedBorder),
            tooltipPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 10.h,
            ),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt().clamp(0, points.length - 1);
                final timestamp = points[index].timestamp as DateTime;
                return LineTooltipItem(
                  NumberFormatter.formatCurrency(spot.y),
                  TextStyle(
                    color: AppColors.accentAmber,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '\n${DateFormat('MMM d, h:mm a').format(timestamp)}',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.15,
            color: lineColor,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  lineColor.withValues(alpha: 0.25),
                  lineColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
