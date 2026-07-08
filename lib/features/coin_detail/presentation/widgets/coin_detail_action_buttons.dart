// features/coin_detail/presentation/widgets/coin_detail_action_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/entities/coin_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CoinDetailActionButtons extends StatelessWidget {
  final CoinEntity coin;

  const CoinDetailActionButtons({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Buy',
            backgroundColor: AppColors.accentAmber,
            textColor: AppColors.bgBase,
            glow: true,
            // Coin obyektini extra kimi ötürürük ki, AddHoldingCubit
            // route açılan kimi bu coin-i preset edə bilsin.
            onTap: () => context.push('/portfolio/add', extra: coin),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _ActionButton(
            label: 'Sell',
            backgroundColor: AppColors.negativeBg,
            textColor: AppColors.negative,
            borderColor: AppColors.negative,
            onTap: () => context.push('/portfolio/sell/${coin.id}'),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final bool glow;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.glow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999.r),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: glow
              ? [
                  BoxShadow(
                    color: AppColors.accentAmberGlow,
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonText.copyWith(color: textColor),
        ),
      ),
    );
  }
}
