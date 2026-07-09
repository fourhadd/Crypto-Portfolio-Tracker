// features/market/presentation/widgets/market_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/market_cubit.dart';
import '../cubit/market_state.dart';
import 'market_filter_bottom_sheet.dart';

class MarketHeader extends StatelessWidget {
  const MarketHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Markets', style: AppTextStyles.displayLarge),
        const _FilterButton(),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MarketCubit, MarketState, bool>(
      selector: (state) => state.hasActiveFilters,
      builder: (context, isFilterActive) {
        return GestureDetector(
          onTap: () => MarketFilterBottomSheet.show(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilterActive
                      ? AppColors.accentAmberGlow
                      : AppColors.bgElevated,
                  border: Border.all(
                    color: isFilterActive
                        ? AppColors.accentAmber
                        : AppColors.bgElevatedBorder,
                  ),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  size: 18.sp,
                  color: isFilterActive
                      ? AppColors.accentAmber
                      : AppColors.textPrimary,
                ),
              ),
              if (isFilterActive)
                Positioned(
                  top: -2.h,
                  right: -2.w,
                  child: Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentAmber,
                      border: Border.all(color: AppColors.bgBase, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
