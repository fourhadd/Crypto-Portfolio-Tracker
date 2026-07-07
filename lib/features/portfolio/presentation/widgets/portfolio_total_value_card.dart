// features/portfolio/presentation/widgets/portfolio_total_value_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';

class PortfolioTotalValueCard extends StatelessWidget {
  const PortfolioTotalValueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.bgElevatedBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TOTAL PORTFOLIO VALUE', style: AppTextStyles.microLabel),
          SizedBox(height: 10.h),
          BlocBuilder<PortfolioCubit, PortfolioState>(
            buildWhen: (prev, curr) =>
                curr is PortfolioLoaded ||
                curr is PortfolioLoading ||
                curr is PortfolioInitial,
            builder: (context, state) {
              final value = state is PortfolioLoaded ? state.totalValue : 0.0;
              return Text(
                '\$${NumberFormat('#,##0.000000', 'en_US').format(value)}',
                style: AppTextStyles.balanceLarge,
              );
            },
          ),
        ],
      ),
    );
  }
}
