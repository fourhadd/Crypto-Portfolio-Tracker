// features/compare/presentation/widgets/comparison_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import 'package:crypto_portfolio_tracker/core/utils/number_formatter.dart';
import '../cubit/compare_cubit.dart';
import '../cubit/compare_state.dart';
import 'comparison_stat_row.dart';

class ComparisonStatsCard extends StatelessWidget {
  const ComparisonStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompareCubit, CompareState>(
      buildWhen: (prev, curr) => prev.result != curr.result,
      builder: (context, state) {
        final result = state.result;
        if (result == null) return const SizedBox.shrink();

        final first = result.first;
        final second = result.second;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: AppGlass.decoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('COMPARISON STATS', style: AppTextStyles.microLabel),
              SizedBox(height: 12.h),
              ComparisonStatRow(
                label: 'Price',
                firstValue: NumberFormatter.formatCurrency(first.currentPrice),
                secondValue: NumberFormatter.formatCurrency(
                  second.currentPrice,
                ),
              ),
              ComparisonStatRow(
                label: '24h Change',
                firstValue: NumberFormatter.formatPercent(
                  first.priceChangePercentage24h,
                ),
                secondValue: NumberFormatter.formatPercent(
                  second.priceChangePercentage24h,
                ),
                firstColor: AppColors.changeColor(
                  first.priceChangePercentage24h,
                ),
                secondColor: AppColors.changeColor(
                  second.priceChangePercentage24h,
                ),
              ),
              ComparisonStatRow(
                label: 'Market Cap',
                firstValue: NumberFormatter.formatCompactVolume(
                  first.marketCap,
                ),
                secondValue: NumberFormatter.formatCompactVolume(
                  second.marketCap,
                ),
              ),
              ComparisonStatRow(
                label: '24h Volume',
                firstValue: NumberFormatter.formatCompactVolume(
                  first.totalVolume24h,
                ),
                secondValue: NumberFormatter.formatCompactVolume(
                  second.totalVolume24h,
                ),
                isLast: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
