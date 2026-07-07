// features/watchlist/presentation/widgets/watchlist_list_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/watchlist_coin_entity.dart';
import '../cubit/watchlist_cubit.dart';
import 'watchlist_sparkline.dart';

class WatchlistListItem extends StatelessWidget {
  final WatchlistCoinEntity item;

  const WatchlistListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final coin = item.coin;
    final isPositive = coin.priceChangePercentage24h >= 0;
    final changeColor = AppColors.changeColor(coin.priceChangePercentage24h);
    final price = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(coin.currentPrice);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: AppGlass.decoration(),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              coin.image,
              width: 40.w,
              height: 40.h,
              errorBuilder: (_, __, ___) => CircleAvatar(
                radius: 20.w,
                backgroundColor: AppColors.bgElevated,
                child: Text(
                  coin.symbol.characters.first,
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
                  style: AppTextStyles.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Rank #${coin.marketCapRank}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 56.w,
            height: 24.h,
            child: WatchlistSparkline(
              values: coin.sparkline,
              color: changeColor,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: AppTextStyles.bodyLarge),
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
          SizedBox(width: 6.w),
          InkWell(
            borderRadius: BorderRadius.circular(999.r),
            onTap: () => context.read<WatchlistCubit>().removeCoin(coin.id),
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: const BoxDecoration(
                color: AppColors.negativeBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline,
                color: AppColors.negative,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
