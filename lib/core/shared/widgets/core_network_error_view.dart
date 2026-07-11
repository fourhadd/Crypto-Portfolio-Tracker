// core/shared/widgets/core_network_error_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CoreNetworkErrorView extends StatelessWidget {
  final String? message;

  final VoidCallback onRetry;

  final bool showConnectionHint;

  final EdgeInsetsGeometry? padding;

  const CoreNetworkErrorView({
    super.key,
    this.message,
    required this.onRetry,
    this.showConnectionHint = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.negativeBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: AppColors.negative,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              message?.trim().isNotEmpty == true
                  ? message!
                  : 'Something went wrong',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (showConnectionHint) ...[
              SizedBox(height: 6.h),
              Text(
                'Check your Wi-Fi/mobile data connection',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh_rounded, size: 18.sp),
              label: Text('Retry', style: AppTextStyles.buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentAmber,
                foregroundColor: AppColors.onAccent,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
