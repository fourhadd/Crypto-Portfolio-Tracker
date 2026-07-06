// features/coin_detail/presentation/widgets/coin_detail_skeleton.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared/widgets/glass_shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/chart_point_entity.dart';

class CoinDetailSkeleton extends StatelessWidget {
  const CoinDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _staticCircleIcon(Icons.arrow_back_rounded),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerBlock(
                      width: 24.w,
                      height: 24.h,
                      shape: BoxShape.circle,
                    ),
                    SizedBox(width: 8.w),
                    ShimmerBlock(width: 90.w, height: 18.h, borderRadius: 4.r),
                    SizedBox(width: 6.w),
                    ShimmerBlock(width: 34.w, height: 14.h, borderRadius: 4.r),
                  ],
                ),
              ),
              _staticCircleIcon(Icons.star_border_rounded),
            ],
          ),
          SizedBox(height: 24.h),
          ShimmerBlock(width: 190.w, height: 36.h, borderRadius: 8.r),
          SizedBox(height: 10.h),
          ShimmerBlock(width: 110.w, height: 26.h, borderRadius: 8.r),
          SizedBox(height: 24.h),
          SizedBox(
            height: 40.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final range in ChartRange.values)
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: _staticRangeChip(
                      range.label,
                      isSelected: range == ChartRange.twentyFourHour,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          ShimmerBlock(
            width: double.infinity,
            height: 220.h,
            borderRadius: 16.r,
          ),
          SizedBox(height: 24.h),
          for (var row = 0; row < 3; row++) ...[
            Row(
              children: [
                Expanded(
                  child: ShimmerBlock(
                    width: double.infinity,
                    height: 62.h,
                    borderRadius: 16.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ShimmerBlock(
                    width: double.infinity,
                    height: 62.h,
                    borderRadius: 16.r,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 54.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.accentAmber,
                    borderRadius: BorderRadius.circular(999.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentAmberGlow,
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    'Buy',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.bgBase,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  height: 54.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.negativeBg,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(color: AppColors.negative),
                  ),
                  child: Text(
                    'Sell',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.negative,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _staticCircleIcon(IconData icon) {
    return Container(
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.bgElevated,
        border: Border.all(color: AppColors.bgElevatedBorder),
      ),
      child: Icon(icon, size: 18.sp, color: AppColors.textPrimary),
    );
  }

  Widget _staticRangeChip(String label, {required bool isSelected}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accentAmberGlow : AppColors.bgElevated,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: isSelected
              ? AppColors.accentAmber
              : AppColors.bgElevatedBorder,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: isSelected ? AppColors.accentAmber : AppColors.textSecondary,
          fontWeight: FontWeight.w700,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}
