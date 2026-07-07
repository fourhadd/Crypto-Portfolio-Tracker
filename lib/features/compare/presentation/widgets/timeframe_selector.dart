// features/compare/presentation/widgets/timeframe_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import '../cubit/compare_cubit.dart';
import '../cubit/compare_state.dart';

class TimeframeSelector extends StatelessWidget {
  const TimeframeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CompareCubit>();

    return BlocBuilder<CompareCubit, CompareState>(
      buildWhen: (prev, curr) => prev.timeframe != curr.timeframe,
      builder: (context, state) {
        return Row(
          children: CompareTimeframe.values.map((tf) {
            final bool selected = tf == state.timeframe;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: tf != CompareTimeframe.month3 ? 8.w : 0,
                ),
                child: GestureDetector(
                  onTap: () => cubit.changeTimeframe(tf),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.accentAmberGlow
                          : AppColors.glassBg,
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                      border: Border.all(
                        color: selected
                            ? AppColors.accentAmber
                            : AppColors.glassBorder,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tf.label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: selected
                            ? AppColors.accentAmber
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
