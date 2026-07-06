// features/market/presentation/widgets/balance_card.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final double todayChangeAmount;
  final double todayChangePercent;
  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.todayChangeAmount,
    required this.todayChangePercent,
    required this.onDeposit,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = AppColors.changeColor(todayChangePercent);
    final radius = 24.r;

    return Container(
      padding: EdgeInsets.all(1.4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.glassHighlight,
            AppColors.glassBorder,
            AppColors.glassBorder.withValues(alpha: 0.4),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1.4),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(radius - 1.4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.glassShadow,
                  blurRadius: 24.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TOTAL BALANCE', style: AppTextStyles.microLabel),
                SizedBox(height: 8.h),
                Text(
                  NumberFormatter.formatCurrency(totalBalance),
                  style: AppTextStyles.balanceLarge,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: changeColor,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '+${NumberFormatter.formatCurrency(todayChangeAmount)} '
                      '(${NumberFormatter.formatPercent(todayChangePercent)}) today',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Deposit',
                        filled: true,
                        onTap: onDeposit,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _ActionButton(
                        label: 'Withdraw',
                        filled: false,
                        onTap: onWithdraw,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.accentAmber : AppColors.bgElevated,
          borderRadius: BorderRadius.circular(16.r),
          border: filled ? null : Border.all(color: AppColors.bgElevatedBorder),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonText.copyWith(
            color: filled ? AppColors.onAccent : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
