// features/portfolio/presentation/widgets/sell_holding_stats_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/number_formatter.dart';
import '../cubit/sell_holding_cubit.dart';
import '../cubit/sell_holding_state.dart';

class SellHoldingStatsRow extends StatelessWidget {
  final double coinPrice;

  const SellHoldingStatsRow({super.key, required this.coinPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'SELL PRICE',
            value: NumberFormatter.formatCurrency(coinPrice),
            caption: 'per unit',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: BlocBuilder<SellHoldingCubit, SellHoldingState>(
            buildWhen: (prev, curr) => prev.sellAmount != curr.sellAmount,
            builder: (context, state) {
              final receive = state.sellAmount * coinPrice;
              return _StatCard(
                label: "YOU'LL RECEIVE",
                value: state.sellAmount <= 0
                    ? '—'
                    : NumberFormatter.formatCurrency(receive),
                caption: 'estimated',
                highlight: state.sellAmount > 0,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String caption;
  final bool highlight;

  const _StatCard({
    required this.label,
    required this.value,
    required this.caption,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppGlass.decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.microLabel),
          SizedBox(height: 6.h),
          Text(
            value,
            style: AppTextStyles.headingMedium.copyWith(
              color: highlight ? AppColors.accentAmber : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(caption, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
