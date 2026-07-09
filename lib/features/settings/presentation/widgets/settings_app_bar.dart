// features/settings/presentation/widgets/settings_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class SettingsAppBar extends StatelessWidget {
  final String title;

  const SettingsAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.bgElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              size: 18.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(title, style: AppTextStyles.headingLarge),
      ],
    );
  }
}
