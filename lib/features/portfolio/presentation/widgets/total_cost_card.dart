// features/portfolio/presentation/widgets/total_cost_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import 'package:crypto_portfolio_tracker/core/utils/number_formatter.dart';

import '../cubit/add_holding_cubit.dart';
import '../cubit/add_holding_state.dart';

class TotalCostCard extends StatelessWidget {
  const TotalCostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddHoldingCubit, AddHoldingState>(
      buildWhen: (prev, curr) =>
          prev.quantity != curr.quantity || prev.buyPrice != curr.buyPrice,
      builder: (context, state) {
        if (state.quantity == null || state.buyPrice == null) {
          return const SizedBox.shrink();
        }

        final totalCost = state.quantity! * state.buyPrice!;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 28.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.accentAmberGlow,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(color: AppColors.accentAmber, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Cost', style: AppTextStyles.bodySmall),
              SizedBox(height: 4.h),
              Text(
                '\$${NumberFormatter.compactUsdFormat.format(totalCost)}',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.accentAmber,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
