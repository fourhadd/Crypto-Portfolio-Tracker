// features/watchlist/presentation/widgets/watchlist_empty_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class WatchlistEmptyState extends StatelessWidget {
  const WatchlistEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88.w,
            height: 88.h,
            decoration: BoxDecoration(
              color: AppColors.accentAmberGlow,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Icon(
              Icons.star_border_rounded,
              color: AppColors.accentAmber,
              size: 40.sp,
            ),
          ),
          SizedBox(height: 24.h),
          Text('No coins starred', style: AppTextStyles.headingMedium),
          SizedBox(height: 8.h),
          Text(
            'Tap the ★ on any coin to add it here',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 32.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.button),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentAmber.withValues(alpha: 0.5),
                  blurRadius: 60.r,
                  spreadRadius: 1.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => context.go('/market'),
              icon: Icon(Icons.add, size: 20.sp),
              label: const Text('Browse Markets'),
            ),
          ),
        ],
      ),
    );
  }
}
