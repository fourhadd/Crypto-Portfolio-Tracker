// features/compare/presentation/widgets/comparison_stat_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class ComparisonStatRow extends StatelessWidget {
  final String label;
  final String firstValue;
  final String secondValue;
  final Color? firstColor;
  final Color? secondColor;
  final bool isLast;

  const ComparisonStatRow({
    super.key,
    required this.label,
    required this.firstValue,
    required this.secondValue,
    this.firstColor,
    this.secondColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  firstValue,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: firstColor ?? AppColors.chartPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  secondValue,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: secondColor ?? AppColors.chartSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, color: AppColors.bgElevatedBorder),
      ],
    );
  }
}
