// features/market/presentation/widgets/market_filter_chips.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/market_cubit.dart';
import '../cubit/market_state.dart';

class MarketFilterChips extends StatelessWidget {
  const MarketFilterChips({super.key});

  static const _filters = ['All', 'Top Gainers', 'Top Losers', 'Volume'];

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MarketCubit, MarketState, String>(
      selector: (state) => state.currentFilter,
      builder: (context, currentFilter) {
        final cubit = context.read<MarketCubit>();

        return SizedBox(
          height: 36.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (_, index) {
              final label = _filters[index];
              final isSelected = currentFilter == label;
              return _FilterChip(
                key: ValueKey(label),
                label: label,
                isSelected: isSelected,
                onTap: () => cubit.changeFilter(label),
              );
            },
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        splashColor: AppColors.accentAmber.withValues(alpha: 0.15),
        highlightColor: AppColors.accentAmber.withValues(alpha: 0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
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
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected
                  ? AppColors.accentAmber
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
