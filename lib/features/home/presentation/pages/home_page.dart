// features/home/presentation/pages/home_page.dart
import 'package:crypto_portfolio_tracker/features/home/presentation/widgets/home_list_header.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/presentation/widgets/select_holding_sheet.dart';
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

  void _handleDeposit(BuildContext context) {
    context.push('/portfolio/add');
  }

  void _handleWithdraw(BuildContext context) {
    final state = context.read<PortfolioCubit>().state;

    if (state.status != PortfolioStatus.loaded || state.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Withdraw etmək üçün əvvəlcə holding əlavə edin'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (sheetContext) => SelectHoldingSheet(
        items: state.items,
        onSelect: (item) {
          Navigator.of(sheetContext).pop();
          context.push('/portfolio/sell/${item.coin.id}');
        },
      ),
    );
  }

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
                    onSettingsTap: () => context.push('/settings'),
                  ),
                  SizedBox(height: 24.h),

                  BlocSelector<
                    PortfolioCubit,
                    PortfolioState,
                    (double, double, double)
                  >(
                    selector: (state) => (
                      state.totalValue,
                      state.todayChangeAmount,
                      state.todayChangePercent,
                    ),
                    builder: (context, values) {
                      final (total, changeAmount, changePercent) = values;
                      return BalanceCard(
                        totalBalance: total,
                        todayChangeAmount: changeAmount,
                        todayChangePercent: changePercent,
                        onDeposit: () => _handleDeposit(context),
                        onWithdraw: () => _handleWithdraw(context),
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
