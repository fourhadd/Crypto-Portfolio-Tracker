// features/coin_detail/presentation/widgets/coin_detail_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared/widgets/glass_shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/coin_detail_cubit.dart';
import '../cubit/coin_detail_state.dart';

class CoinDetailChart extends StatelessWidget {
  const CoinDetailChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDetailCubit, CoinDetailState>(
      buildWhen: (previous, current) => current is CoinDetailLoaded,
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
              : _Chart(coin: state.coin, points: state.chartPoints),
        );
      },
    );
  }
}

class _Chart extends StatelessWidget {
  final dynamic coin;
  final List<dynamic> points;

  const _Chart({required this.coin, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    final isPositive = coin.priceChangePercentage24h >= 0;
    final lineColor = isPositive ? AppColors.positive : AppColors.negative;

    final spots = <FlSpot>[
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].price as double),
    ];

    final prices = points.map((p) => p.price as double).toList();
    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return LineChart(
      LineChartData(
        minY: minY - padding,
        maxY: maxY + padding,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
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
