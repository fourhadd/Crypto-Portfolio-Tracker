// features/watchlist/presentation/widgets/watchlist_list_item.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_portfolio_tracker/core/utils/number_formatter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/watchlist_coin_entity.dart';
import 'watchlist_sparkline.dart';

class WatchlistListItem extends StatelessWidget {
  final WatchlistCoinEntity item;

  const WatchlistListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final coin = item.coin;

    final isPositive = coin.priceChangePercentage24h >= 0;
    final changeColor = AppColors.changeColor(coin.priceChangePercentage24h);

    final price = NumberFormatter.usdCurrencyFormat.format(coin.currentPrice);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () => context.push('/coin/${coin.id}', extra: coin),
        child: Ink(
          decoration: AppGlass.decoration(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: coin.image,
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => CircleAvatar(
                      radius: 20.r,
                      backgroundColor: AppColors.bgElevated,
                    ),
                    errorWidget: (_, __, ___) => CircleAvatar(
                      radius: 20.r,
                      backgroundColor: AppColors.bgElevated,
                      child: Text(
                        coin.symbol.characters.first.toUpperCase(),
                        style: AppTextStyles.tokenSymbol,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyLarge,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${coin.symbol.toUpperCase()} • Rank #${coin.marketCapRank}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w),

                SizedBox(
                  width: 56.w,
                  height: 24.h,
                  child: WatchlistSparkline(
                    values: coin.sparkline,
                    color: changeColor,
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${isPositive ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                        style: AppTextStyles.percentChange.copyWith(
                          color: changeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
