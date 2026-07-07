// features/portfolio/presentation/widgets/portfolio_empty_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class PortfolioEmptyState extends StatelessWidget {
  const PortfolioEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentAmberGlow,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Icon(
              Icons.pie_chart_outline_rounded,
              size: 40.sp,
              color: AppColors.accentAmber,
            ),
          ),
          SizedBox(height: 24.h),
          Text('No holdings yet', style: AppTextStyles.headingMedium),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'Start tracking your crypto portfolio by adding your first holding',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/portfolio/add'),
              icon: Icon(
                Icons.add_rounded,
                size: 20.sp,
                color: AppColors.onAccent,
              ),
              label: Text(
                'Add First Holding',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.onAccent,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentAmber,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
