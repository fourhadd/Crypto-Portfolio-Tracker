// features/composition/presentation/widgets/composition_list.dart
import 'package:crypto_portfolio_tracker/features/composition/presentation/cubit/composition_state.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/domain/entities/portfolio_coin_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import 'composition_palette.dart';

class CompositionList extends StatelessWidget {
  final List<PortfolioCoinEntity> items;
  final CompositionMode mode;

  const CompositionList({super.key, required this.items, required this.mode});

  double _weightOf(PortfolioCoinEntity item) {
    return mode == CompositionMode.byValue
        ? item.currentValue
        : item.holding.amount;
  }

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (sum, item) => sum + _weightOf(item));

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.bgElevatedBorder, width: 1),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final weight = _weightOf(item);
          final percent = total == 0 ? 0.0 : (weight / total) * 100;
          final color = compositionPaletteColor(index);

          final valueLabel = mode == CompositionMode.byValue
              ? '\$${NumberFormat('#,##0.00', 'en_US').format(weight)}'
              : NumberFormat('#,##0.0000').format(weight);

          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: index == items.length - 1
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: AppColors.bgElevatedBorder,
                        width: 1,
                      ),
                    ),
            ),
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10.w),
                ClipOval(
                  child: Image.network(
                    item.coin.image,
                    width: 28.w,
                    height: 28.w,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.currency_bitcoin,
                      size: 28.w,
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
                      SizedBox(height: 6.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: percent / 100,
                          minHeight: 4.h,
                          backgroundColor: AppColors.bgElevatedBorder,
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(valueLabel, style: AppTextStyles.bodyMedium),
                    Text(
                      '${percent.toStringAsFixed(1)}%',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
