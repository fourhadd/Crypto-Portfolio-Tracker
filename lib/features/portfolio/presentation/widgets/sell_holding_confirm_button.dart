// features/portfolio/presentation/widgets/sell_holding_confirm_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/sell_holding_cubit.dart';
import '../cubit/sell_holding_state.dart';

class SellHoldingConfirmButton extends StatelessWidget {
  final String coinSymbol;

  const SellHoldingConfirmButton({super.key, required this.coinSymbol});

  Future<void> _confirmAndSubmit(BuildContext context, double amount) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.bgSurfaceSolid,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.bgElevatedBorder),
        ),
        title: Text('Confirm Sale', style: AppTextStyles.headingMedium),
        content: Text(
          'Sell ${amount.toStringAsFixed(6)} ${coinSymbol.toUpperCase()}?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Sell',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.accentAmber,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<SellHoldingCubit>().submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellHoldingCubit, SellHoldingState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == SellHoldingStatus.success) {
          context.pop();
        } else if (state.status == SellHoldingStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Xəta baş verdi')),
          );
        }
      },
      buildWhen: (prev, curr) =>
          prev.sellAmount != curr.sellAmount || prev.status != curr.status,
      builder: (context, state) {
        final enabled = state.sellAmount > 0 && !state.isSubmitting;

        return SizedBox(
          width: double.infinity,
          height: 54.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: enabled
                  ? AppColors.negativeBg
                  : AppColors.bgElevated,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
                side: BorderSide(
                  color: enabled
                      ? AppColors.negative
                      : AppColors.bgElevatedBorder,
                ),
              ),
            ),
            onPressed: enabled
                ? () => _confirmAndSubmit(context, state.sellAmount)
                : null,
            child: state.isSubmitting
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.negative,
                    ),
                  )
                : Text(
                    'Confirm Sell',
                    style: AppTextStyles.buttonText.copyWith(
                      color: enabled
                          ? AppColors.negative
                          : AppColors.textTertiary,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
