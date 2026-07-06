// features/home/presentation/widgets/home_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeAppBar extends StatelessWidget {
  final String userName;
  final VoidCallback onStatsTap;
  final VoidCallback onSettingsTap;

  const HomeAppBar({
    super.key,
    required this.userName,
    required this.onStatsTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Avatar(letter: userName.isNotEmpty ? userName[0].toUpperCase() : '?'),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good morning', style: AppTextStyles.bodySmall),
              Text(userName, style: AppTextStyles.headingMedium),
            ],
          ),
        ),
        _IconButtonCircle(icon: Icons.bar_chart_rounded, onTap: onStatsTap),
        SizedBox(width: 8.w),
        _IconButtonCircle(icon: Icons.settings_rounded, onTap: onSettingsTap),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String letter;

  const _Avatar({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.h,
      decoration: const BoxDecoration(
        color: AppColors.accentAmber,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: AppTextStyles.headingMedium.copyWith(color: AppColors.onAccent),
      ),
    );
  }
}

class _IconButtonCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButtonCircle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.bgElevatedBorder),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.textPrimary, size: 20.sp),
      ),
    );
  }
}
