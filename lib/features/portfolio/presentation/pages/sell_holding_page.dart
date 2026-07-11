// features/portfolio/presentation/pages/sell_holding_page.dart
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/shared/cubit/connectivity_cubit.dart';
import '../../domain/entities/portfolio_coin_entity.dart';
import '../../domain/usecases/sell_holding_usecase.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import '../cubit/sell_holding_cubit.dart';
import '../widgets/sell_holding_amount_input.dart';
import '../widgets/sell_holding_confirm_button.dart';
import '../widgets/sell_holding_holding_card.dart';
import '../widgets/sell_holding_stats_row.dart';

class SellHoldingPage extends StatelessWidget {
  final String coinId;

  const SellHoldingPage({super.key, required this.coinId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child:
            BlocSelector<
              PortfolioCubit,
              PortfolioState,
              (PortfolioStatus, PortfolioCoinEntity?)
            >(
              selector: (state) {
                if (state.status != PortfolioStatus.loaded) {
                  return (state.status, null);
                }
                // firstWhereOrNull is a defensive guard: each coin has at
                // most one merged lot by this point.
                final item = state.items.firstWhereOrNull(
                  (i) => i.holding.coinId == coinId,
                );
                return (state.status, item);
              },
              builder: (context, value) {
                final (status, item) = value;

                if (status != PortfolioStatus.loaded) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentAmber,
                    ),
                  );
                }

                if (item == null) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Text(
                        'Bu coin portfelinizdə tapılmadı.',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return BlocProvider(
                  create: (_) => SellHoldingCubit(
                    sellHoldingUseCase: sl<SellHoldingUseCase>(),
                    connectivityCubit: sl<ConnectivityCubit>(),
                    holdingId: item.holding.id,
                    maxAmount: item.holding.amount,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        SellHoldingHoldingCard(
                          coin: item.coin,
                          holding: item.holding,
                        ),
                        SizedBox(height: 20.h),
                        SellHoldingAmountInput(
                          coinSymbol: item.coin.symbol,
                          maxAmount: item.holding.amount,
                        ),
                        SizedBox(height: 16.h),
                        SellHoldingStatsRow(coinPrice: item.coin.currentPrice),
                        const Spacer(),
                        SellHoldingConfirmButton(coinSymbol: item.coin.symbol),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
