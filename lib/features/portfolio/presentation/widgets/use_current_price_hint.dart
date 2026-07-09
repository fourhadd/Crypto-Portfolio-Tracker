// features/portfolio/presentation/widgets/use_current_price_hint.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import 'package:crypto_portfolio_tracker/core/utils/number_formatter.dart';

import '../cubit/add_holding_cubit.dart';
import '../cubit/add_holding_state.dart';

class UseCurrentPriceHint extends StatelessWidget {
  const UseCurrentPriceHint({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddHoldingCubit, AddHoldingState>(
      buildWhen: (prev, curr) => prev.coin != curr.coin,
      builder: (context, state) {
        if (state.coin == null) return const SizedBox.shrink();

        final priceText = NumberFormatter.usdFormat.format(
          state.coin!.currentPrice,
        );

        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: InkWell(
            onTap: () => context.read<AddHoldingCubit>().updateBuyPrice(
              state.coin!.currentPrice.toString(),
            ),
            child: Text(
              'Use current price (\$$priceText)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.accentAmber,
              ),
            ),
          ),
        );
      },
    );
  }
}
