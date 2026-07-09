// features/settings/presentation/widgets/settings_about_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class SettingsAboutFooter extends StatelessWidget {
  const SettingsAboutFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.accentAmber, width: 1),
          ),
          child: Icon(
            Icons.show_chart_rounded,
            color: AppColors.accentAmber,
            size: 26.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'CryptoTrack',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4.h),
        Text('Premium Portfolio Tracker', style: AppTextStyles.bodySmall),
      ],
    );
  }
}
