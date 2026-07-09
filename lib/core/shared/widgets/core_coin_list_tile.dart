// core/shared/widgets/core_coin_list_tile.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/coin_entity.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/number_formatter.dart';
import '../../../features/watchlist/presentation/widgets/watchlist_sparkline.dart';

class CoreCoinListTile extends StatelessWidget {
  final int rank;
  final CoinEntity coin;
  final VoidCallback? onTap;
  final bool showSparkline;
  final bool showVolume;

  const CoreCoinListTile({
    super.key,
    required this.rank,
    required this.coin,
    this.onTap,
    this.showSparkline = false,
    this.showVolume = false,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = AppColors.changeColor(coin.priceChangePercentage24h);
    final changeBg = AppColors.changeBgColor(coin.priceChangePercentage24h);
    final isPositive = coin.priceChangePercentage24h >= 0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            SizedBox(
              width: 24.w,
              child: Text(
                '$rank',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),

            ClipOval(
              child: CachedNetworkImage(
                imageUrl: coin.image,
                width: 32.w,
                height: 32.h,
                placeholder: (_, __) => Container(
                  width: 32.w,
                  height: 32.h,
                  color: AppColors.bgElevated,
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 32.w,
                  height: 32.h,
                  color: AppColors.bgElevated,
                  child: Icon(Icons.currency_bitcoin, size: 16.sp),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    coin.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    coin.symbol.toUpperCase(),
                    style: AppTextStyles.tokenSymbol.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (showSparkline)
              Expanded(
                flex: 2,
                child: Container(
                  height: 32.h,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  child: coin.sparkline.length >= 2
                      ? WatchlistSparkline(
                          values: coin.sparkline,
                          color: isPositive
                              ? AppColors.positive
                              : AppColors.negative,
                        )
                      : Container(
                          height: 1.5.h,
                          color: isPositive
                              ? AppColors.positive
                              : AppColors.negative,
                        ),
                ),
              ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    NumberFormatter.formatCurrency(coin.currentPrice),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: changeBg,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '${isPositive ? '▲' : '▼'} ${isPositive ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                      style: AppTextStyles.microLabel.copyWith(
                        color: changeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
