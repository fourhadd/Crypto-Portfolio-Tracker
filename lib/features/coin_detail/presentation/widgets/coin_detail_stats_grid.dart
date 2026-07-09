// features/coin_detail/presentation/widgets/coin_detail_stats_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../cubit/coin_detail_cubit.dart';
import '../cubit/coin_detail_state.dart';

class CoinDetailStatsGrid extends StatelessWidget {
  const CoinDetailStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDetailCubit, CoinDetailState>(
      buildWhen: (previous, current) =>
          current is CoinDetailLoaded &&
          (previous is! CoinDetailLoaded || previous.coin != current.coin),
      builder: (context, state) {
        if (state is! CoinDetailLoaded) return const SizedBox.shrink();
        final coin = state.coin;
        final athChange = coin.athChangePercentage;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Market Cap',
                    value: NumberFormatter.formatCompactVolume(coin.marketCap),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    label: '24h Volume',
                    value: NumberFormatter.formatCompactVolume(
                      coin.totalVolume,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: '24h High',
                    value: NumberFormatter.formatCurrency(coin.high24h ?? 0),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    label: '24h Low',
                    value: NumberFormatter.formatCurrency(coin.low24h ?? 0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'All Time High',
                    value: NumberFormatter.formatCurrency(coin.ath ?? 0),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    label: 'ATH Change',
                    value: athChange != null
                        ? NumberFormatter.formatPercent(athChange)
                        : '—',
                    valueColor: athChange != null
                        ? AppColors.changeColor(athChange)
                        : null,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatCard({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.bgElevatedBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
