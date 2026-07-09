// features/home/presentation/widgets/balance_card.dart
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
                _BalanceAmount(totalBalance: totalBalance),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      todayChangePercent >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: changeColor,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${todayChangeAmount >= 0 ? '+' : ''}${NumberFormatter.formatCurrency(todayChangeAmount)} '
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

class _BalanceAmount extends StatelessWidget {
  final double totalBalance;

  const _BalanceAmount({required this.totalBalance});

  @override
  Widget build(BuildContext context) {
    final formatted = NumberFormatter.formatCurrency(totalBalance);
    final dotIndex = formatted.lastIndexOf(',');

    if (dotIndex == -1) {
      return Text(formatted, style: AppTextStyles.balanceLarge);
    }

    final wholePart = formatted.substring(0, dotIndex);
    final decimalPart = formatted.substring(dotIndex + 1);

    return RichText(
      text: TextSpan(
        style: AppTextStyles.balanceLarge,
        children: [
          TextSpan(text: wholePart),
          WidgetSpan(child: SizedBox(width: 6.w)),
          TextSpan(
            text: '.$decimalPart',
            style: AppTextStyles.balanceLarge.copyWith(
              fontSize: (AppTextStyles.balanceLarge.fontSize ?? 32.sp) * 0.5,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
