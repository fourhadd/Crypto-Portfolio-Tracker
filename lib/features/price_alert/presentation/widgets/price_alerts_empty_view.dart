// features/alerts/presentation/widgets/price_alerts_empty_view.dart
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class PriceAlertsEmptyView extends StatelessWidget {
  const PriceAlertsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.notifications_none,
              size: 32.sp,
              color: AppColors.accentAmber,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No alerts yet',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20.h),
          InkWell(
            onTap: () => context.read<PriceAlertsCubit>().openCreateSheet(),
            borderRadius: BorderRadius.circular(30.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.accentAmber,
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentAmberGlow,
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: AppColors.onAccent),
                  SizedBox(width: 8.w),
                  Text(
                    'Create Alert',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.onAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
