// features/home/presentation/pages/home_page.dart
import 'package:crypto_portfolio_tracker/features/home/presentation/widgets/home_list_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../portfolio/presentation/cubit/portfolio_cubit.dart';
import '../../../portfolio/presentation/cubit/portfolio_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/coin_list_view.dart';
import '../widgets/home_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(
        children: [
          Positioned(
            top: -60.h,
            left: -40.w,
            child: _GlowBlob(color: AppColors.accentAmberGlow, size: 220.w),
          ),
          Positioned(
            top: 220.h,
            right: -60.w,
            child: _GlowBlob(
              color: AppColors.chartSecondary.withValues(alpha: 0.18),
              size: 180.w,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeAppBar(
                    userName: 'Crypto Trader',
                    onStatsTap: () => context.push('/compare'),
                    onSettingsTap: () {},
                  ),
                  SizedBox(height: 24.h),
                  BlocBuilder<PortfolioCubit, PortfolioState>(
                    builder: (context, state) {
                      double totalBalance = 0;
                      double todayChangeAmount = 0;

                      if (state is PortfolioLoaded) {
                        for (final item in state.items) {
                          totalBalance += item.currentValue;
                          final changeAmount =
                              item.currentValue *
                              (item.coin.priceChangePercentage24h / 100);
                          todayChangeAmount += changeAmount;
                        }
                      }

                      final yesterdayValue = totalBalance - todayChangeAmount;
                      final todayChangePercent = yesterdayValue == 0
                          ? 0.0
                          : (todayChangeAmount / yesterdayValue) * 100;

                      return BalanceCard(
                        totalBalance: totalBalance,
                        todayChangeAmount: todayChangeAmount,
                        todayChangePercent: todayChangePercent,
                        onDeposit: () {},
                        onWithdraw: () {},
                      );
                    },
                  ),
                  SizedBox(height: 28.h),
                  HomeListHeader(onSeeAllTap: () => context.go('/market')),
                  SizedBox(height: 8.h),
                  CoinListView(onCoinTap: (id) => context.push('/coin/$id')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}
