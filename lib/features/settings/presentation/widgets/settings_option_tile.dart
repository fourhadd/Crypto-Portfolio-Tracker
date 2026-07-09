// features/settings/presentation/widgets/settings_option_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

/// Currency / Refresh Interval kimi açıla bilən siyahılar üçün seçim sətri.
class SettingsOptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SettingsOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        color: selected
            ? AppColors.accentAmber.withValues(alpha: 0.12)
            : Colors.transparent,
        padding: EdgeInsets.only(
          left: 62.w,
          right: 14.w,
          top: 14.h,
          bottom: 14.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: selected
                      ? AppColors.accentAmber
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check, size: 18.sp, color: AppColors.accentAmber),
          ],
        ),
      ),
    );
  }
}
