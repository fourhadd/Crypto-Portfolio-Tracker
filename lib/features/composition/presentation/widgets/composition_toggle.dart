// features/composition/presentation/widgets/composition_toggle.dart
import 'package:crypto_portfolio_tracker/features/composition/presentation/cubit/composition_mode_cubit.dart';
import 'package:crypto_portfolio_tracker/features/composition/presentation/cubit/composition_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class CompositionToggle extends StatelessWidget {
  const CompositionToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompositionModeCubit, CompositionState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: _ToggleButton(
                label: 'By Value',
                selected: state.mode == CompositionMode.byValue,
                onTap: () => context.read<CompositionModeCubit>().setByValue(),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ToggleButton(
                label: 'By Count',
                selected: state.mode == CompositionMode.byCount,
                onTap: () => context.read<CompositionModeCubit>().setByCount(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.chip),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentAmberGlow : AppColors.bgElevated,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: selected
                ? AppColors.accentAmber
                : AppColors.bgElevatedBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonText.copyWith(
            color: selected ? AppColors.accentAmber : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
