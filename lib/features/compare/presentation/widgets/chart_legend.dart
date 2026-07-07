// features/compare/presentation/widgets/chart_legend.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class ChartLegend extends StatelessWidget {
  final String firstSymbol;
  final String secondSymbol;

  const ChartLegend({
    super.key,
    required this.firstSymbol,
    required this.secondSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _dot(AppColors.chartPrimary, firstSymbol),
        SizedBox(width: 16.w),
        _dot(AppColors.chartSecondary, secondSymbol),
      ],
    );
  }

  Widget _dot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
