// features/market/presentation/widgets/market_search_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/market_cubit.dart';

class MarketSearchField extends StatelessWidget {
  const MarketSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.bgElevatedBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 20.sp, color: AppColors.textTertiary),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search coins...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              onChanged: (value) =>
                  context.read<MarketCubit>().updateSearchQuery(value),
            ),
          ),
        ],
      ),
    );
  }
}
