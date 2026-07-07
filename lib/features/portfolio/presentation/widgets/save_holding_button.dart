// features/portfolio/presentation/widgets/save_holding_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

import '../cubit/add_holding_cubit.dart';
import '../cubit/add_holding_state.dart';

class SaveHoldingButton extends StatelessWidget {
  const SaveHoldingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddHoldingCubit, AddHoldingState>(
      buildWhen: (prev, curr) =>
          prev.isValid != curr.isValid || prev.status != curr.status,
      builder: (context, state) {
        final enabled = state.isValid && !state.isSubmitting;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: enabled
                ? () => context.read<AddHoldingCubit>().submit()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: enabled
                  ? AppColors.accentAmber
                  : AppColors.bgElevated,
              disabledBackgroundColor: AppColors.bgElevated,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
                side: enabled
                    ? BorderSide.none
                    : const BorderSide(color: AppColors.bgElevatedBorder),
              ),
            ),
            child: state.isSubmitting
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onAccent,
                    ),
                  )
                : Text(
                    'Save Holding',
                    style: AppTextStyles.buttonText.copyWith(
                      color: enabled
                          ? AppColors.onAccent
                          : AppColors.textTertiary,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
