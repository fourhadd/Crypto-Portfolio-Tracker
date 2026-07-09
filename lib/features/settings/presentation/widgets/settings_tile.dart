// features/settings/presentation/widgets/settings_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final bool isLoading;
  final VoidCallback? onTap;

  /// [onTap] var olduqda göstərilən sağ ikon. Defolt: [Icons.chevron_right].
  /// Açıla bilən siyahılarda (Currency, Refresh Interval) açıq/qapalı
  /// vəziyyəti bildirmək üçün istifadə olunur.
  final IconData? trailingIcon;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.isLoading = false,
    this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
              child: Icon(icon, size: 18.sp, color: AppColors.accentAmber),
            ),
            SizedBox(width: 12.w),
            Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
            if (isLoading)
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accentAmber,
                ),
              )
            else ...[
              if (trailingText != null)
                Text(trailingText!, style: AppTextStyles.bodySmall),
              if (onTap != null) ...[
                SizedBox(width: 4.w),
                Icon(
                  trailingIcon ?? Icons.chevron_right,
                  size: 18.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
