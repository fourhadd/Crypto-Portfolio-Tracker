// features/onboarding/presentation/widgets/onboarding_slide.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import 'onboarding_slide_data.dart';

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData data;

  const OnboardingSlide({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160.w,
            height: 160.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: data.iconColor.withValues(alpha: 0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: data.iconColor.withValues(alpha: 0.18),
                  blurRadius: 60.r,
                  spreadRadius: 10.r,
                ),
              ],
            ),
            child: Icon(data.icon, size: 56.sp, color: data.iconColor),
          ),
          SizedBox(height: 40.h),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.tagline,
          ),
          SizedBox(height: 16.h),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
