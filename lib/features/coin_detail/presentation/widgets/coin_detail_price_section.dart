// features/coin_detail/presentation/widgets/coin_detail_price_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../cubit/coin_detail_cubit.dart';
import '../cubit/coin_detail_state.dart';

class CoinDetailPriceSection extends StatelessWidget {
  const CoinDetailPriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDetailCubit, CoinDetailState>(
      buildWhen: (previous, current) => current is CoinDetailLoaded,
      builder: (context, state) {
        if (state is! CoinDetailLoaded) return const SizedBox.shrink();
        final coin = state.coin;
        final isPositive = coin.priceChangePercentage24h >= 0;
        final changeColor = AppColors.changeColor(
          coin.priceChangePercentage24h,
        );
        final changeBg = AppColors.changeBgColor(coin.priceChangePercentage24h);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              NumberFormatter.formatCurrency(coin.currentPrice),
              style: AppTextStyles.displayLarge,
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: changeBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '${isPositive ? '▲' : '▼'} ${isPositive ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}% (24h)',
                style: AppTextStyles.percentChange.copyWith(
                  color: changeColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
