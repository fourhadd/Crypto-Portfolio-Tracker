// features/portfolio/presentation/widgets/add_holding_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class AddHoldingHeader extends StatelessWidget {
  const AddHoldingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.bgElevatedBorder, width: 1),
            ),
            child: Icon(
              Icons.close_rounded,
              color: AppColors.textPrimary,
              size: 20.sp,
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Text(
          'Add Holding',
          style: AppTextStyles.headingLarge.copyWith(fontSize: 22.sp),
        ),
      ],
    );
  }
}
