// features/portfolio/presentation/widgets/coin_select_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import 'package:crypto_portfolio_tracker/features/compare/presentation/widgets/coin_picker_bottom_sheet.dart';

import '../cubit/add_holding_cubit.dart';
import '../cubit/add_holding_state.dart';

class CoinSelectField extends StatelessWidget {
  const CoinSelectField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddHoldingCubit, AddHoldingState>(
      buildWhen: (prev, curr) => prev.coin != curr.coin,
      builder: (context, state) {
        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.chip),
          onTap: () async {
            final coin = await CoinPickerBottomSheet.show(context);
            if (coin != null && context.mounted) {
              context.read<AddHoldingCubit>().selectCoin(coin);
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(AppRadius.chip),
              border: Border.all(color: AppColors.glassBorder, width: 1),
            ),
            child: Row(
              children: [
                if (state.coin != null) ...[
                  ClipOval(
                    child: Image.network(
                      state.coin!.image,
                      width: 22.w,
                      height: 22.w,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.currency_bitcoin,
                        size: 22.w,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
                Expanded(
                  child: Text(
                    state.coin != null
                        ? '${state.coin!.name} (${state.coin!.symbol.toUpperCase()})'
                        : 'Select a coin...',
                    style: state.coin != null
                        ? AppTextStyles.bodyMedium
                        : AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 22.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
