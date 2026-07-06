// features/market/presentation/widgets/coin_list_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/coin_entity.dart';

class CoinListTile extends StatelessWidget {
  final int rank;
  final CoinEntity coin;
  final VoidCallback onTap;

  const CoinListTile({
    super.key,
    required this.rank,
    required this.coin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = AppColors.changeColor(coin.priceChangePercentage24h);
    final changeBg = AppColors.changeBgColor(coin.priceChangePercentage24h);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              child: Text('$rank', style: AppTextStyles.bodySmall),
            ),
            SizedBox(width: 8.w),
            ClipOval(
              child: Image.network(
                coin.image,
                width: 40.w,
                height: 40.w,
                errorBuilder: (_, __, ___) => Container(
                  width: 40.w,
                  height: 40.w,
                  color: AppColors.bgElevated,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coin.name, style: AppTextStyles.bodyLarge),
                  Text(
                    '${coin.symbol} · Vol '
                    '${NumberFormatter.formatCompactVolume(coin.totalVolume)}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormatter.formatCurrency(coin.currentPrice),
                  style: AppTextStyles.bodyLarge,
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: changeBg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    NumberFormatter.formatPercent(
                      coin.priceChangePercentage24h,
                    ),
                    style: AppTextStyles.bodySmall.copyWith(color: changeColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
