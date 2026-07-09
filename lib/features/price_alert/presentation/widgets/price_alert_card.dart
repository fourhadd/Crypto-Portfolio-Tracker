// features/alerts/presentation/widgets/price_alert_card.dart
import 'package:crypto_portfolio_tracker/features/price_alert/domain/entities/alert_entity.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class PriceAlertCard extends StatelessWidget {
  final PriceAlert alert;

  const PriceAlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final conditionLabel = alert.condition == AlertCondition.above
        ? 'above'
        : 'below';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: AppColors.bgElevatedBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentAmber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              size: 18.sp,
              color: AppColors.accentAmber,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.symbol,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$conditionLabel \$${alert.targetPrice.toStringAsFixed(2)}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: alert.isActive,
            activeThumbColor: AppColors.accentAmber,
            onChanged: (v) =>
                context.read<PriceAlertsCubit>().toggleAlert(alert.id, v),
          ),
          InkWell(
            onTap: () => context.read<PriceAlertsCubit>().removeAlert(alert.id),
            child: Icon(
              Icons.close,
              size: 18.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
