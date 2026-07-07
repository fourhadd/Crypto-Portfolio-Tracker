// features/portfolio/presentation/widgets/portfolio_holding_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

import '../../domain/entities/portfolio_coin_entity.dart';

class PortfolioHoldingTile extends StatelessWidget {
  final PortfolioCoinEntity item;

  const PortfolioHoldingTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final changeColor = AppColors.changeColor(item.profitLossPercent);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: AppColors.bgElevatedBorder, width: 1),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              item.coin.image,
              width: 36.w,
              height: 36.w,
              errorBuilder: (_, __, ___) => Icon(
                Icons.currency_bitcoin,
                size: 36.w,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.coin.name, style: AppTextStyles.bodyMedium),
                Text(
                  '${item.holding.amount} ${item.coin.symbol.toUpperCase()}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${NumberFormat('#,##0.00').format(item.currentValue)}',
                style: AppTextStyles.bodyMedium,
              ),
              Text(
                '${item.profitLossPercent >= 0 ? '+' : ''}'
                '${item.profitLossPercent.toStringAsFixed(2)}%',
                style: AppTextStyles.bodySmall.copyWith(color: changeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
