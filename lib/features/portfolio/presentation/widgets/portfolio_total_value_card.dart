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

  static final _usdFormat = NumberFormat('#,##0.00', 'en_US');

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
          BlocSelector<PortfolioCubit, PortfolioState, double>(
            selector: (state) =>
                state.status == PortfolioStatus.loaded ? state.totalValue : 0.0,
            builder: (context, totalValue) {
              return Text(
                '\$${_usdFormat.format(totalValue)}',
                style: AppTextStyles.balanceLarge,
              );
            },
          ),
        ],
      ),
    );
  }
}
