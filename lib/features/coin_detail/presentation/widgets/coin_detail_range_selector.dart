// features/coin_detail/presentation/widgets/coin_detail_range_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/chart_point_entity.dart';
import '../cubit/coin_detail_cubit.dart';
import '../cubit/coin_detail_state.dart';

class CoinDetailRangeSelector extends StatelessWidget {
  const CoinDetailRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDetailCubit, CoinDetailState>(
      buildWhen: (previous, current) =>
          current is CoinDetailLoaded &&
          (previous is! CoinDetailLoaded ||
              previous.selectedRange != current.selectedRange),
      builder: (context, state) {
        if (state is! CoinDetailLoaded) return const SizedBox.shrink();
        final cubit = context.read<CoinDetailCubit>();

        return SizedBox(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ChartRange.values.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (_, index) {
              final range = ChartRange.values[index];
              final isSelected = state.selectedRange == range;

              return GestureDetector(
                onTap: () => cubit.changeRange(range),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accentAmberGlow
                        : AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentAmber
                          : AppColors.bgElevatedBorder,
                    ),
                  ),
                  child: Text(
                    range.label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.accentAmber
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
