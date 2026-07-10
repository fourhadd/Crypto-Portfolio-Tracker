// features/home/presentation/widgets/home_list_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeListHeader extends StatelessWidget {
  final VoidCallback onSeeAllTap;

  const HomeListHeader({super.key, required this.onSeeAllTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('POPULAR CRYPTOCURRENCY', style: AppTextStyles.microLabel),
        GestureDetector(
          onTap: onSeeAllTap,
          child: Row(
            children: [
              Text(
                'See all',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.accentAmber,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.accentAmber,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
