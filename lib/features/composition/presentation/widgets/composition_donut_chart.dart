// features/composition/presentation/widgets/composition_donut_chart.dart
import 'package:crypto_portfolio_tracker/features/composition/presentation/cubit/composition_state.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/domain/entities/portfolio_coin_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import 'package:crypto_portfolio_tracker/core/utils/number_formatter.dart';
import 'composition_palette.dart';

class CompositionDonutChart extends StatelessWidget {
  final List<PortfolioCoinEntity> items;
  final CompositionMode mode;

  const CompositionDonutChart({
    super.key,
    required this.items,
    required this.mode,
  });

  double _weightOf(PortfolioCoinEntity item) {
    return mode == CompositionMode.byValue
        ? item.currentValue
        : item.holding.amount;
  }

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (sum, item) => sum + _weightOf(item));

    final centerLabel = mode == CompositionMode.byValue
        ? '\$${NumberFormatter.usdFormat.format(total)}'
        : '${items.length} coin${items.length == 1 ? '' : 's'}';

    return SizedBox(
      height: 240.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 70.r,
              sections: List.generate(items.length, (index) {
                final value = _weightOf(items[index]);
                return PieChartSectionData(
                  value: value <= 0 ? 0.0001 : value,
                  color: compositionPaletteColor(index),
                  radius: 50.r,
                  showTitle: false,
                );
              }),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('TOTAL', style: AppTextStyles.microLabel),
              SizedBox(height: 4.h),
              Text(centerLabel, style: AppTextStyles.headingMedium),
            ],
          ),
        ],
      ),
    );
  }
}
