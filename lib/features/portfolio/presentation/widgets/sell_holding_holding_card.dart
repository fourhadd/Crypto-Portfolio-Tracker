// features/portfolio/presentation/widgets/sell_holding_holding_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/domain/entities/coin_entity.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/holding_entity.dart';

class SellHoldingHoldingCard extends StatelessWidget {
  final CoinEntity coin;
  final HoldingEntity holding;

  const SellHoldingHoldingCard({
    super.key,
    required this.coin,
    required this.holding,
  });

  @override
  Widget build(BuildContext context) {
    final estimatedValue = holding.amount * coin.currentPrice;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: AppGlass.decoration(),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              coin.image,
              width: 48.w,
              height: 48.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 48.w,
                height: 48.w,
                color: AppColors.bgElevatedBorder,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('YOUR HOLDING', style: AppTextStyles.microLabel),
              SizedBox(height: 4.h),
              Text(
                '${_trim(holding.amount)} ${coin.symbol.toUpperCase()}',
                style: AppTextStyles.headingLarge,
              ),
              SizedBox(height: 2.h),
              Text(
                '≈ ${NumberFormatter.formatCurrency(estimatedValue)}',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _trim(double value) {
    final str = value.toStringAsFixed(8);
    return str
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}
