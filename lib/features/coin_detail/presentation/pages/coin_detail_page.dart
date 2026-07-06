// features/coin_detail/presentation/pages/coin_detail_page.dart
import 'package:crypto_portfolio_tracker/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/coin_detail_cubit.dart';
import '../cubit/coin_detail_state.dart';
import '../widgets/coin_detail_app_bar.dart';
import '../widgets/coin_detail_price_section.dart';
import '../widgets/coin_detail_range_selector.dart';
import '../widgets/coin_detail_chart.dart';
import '../widgets/coin_detail_stats_grid.dart';
import '../widgets/coin_detail_action_buttons.dart';
import '../widgets/coin_detail_skeleton.dart';

class CoinDetailPage extends StatelessWidget {
  final String coinId;

  const CoinDetailPage({super.key, required this.coinId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CoinDetailCubit>()..loadCoin(coinId),
      child: const _CoinDetailView(),
    );
  }
}

class _CoinDetailView extends StatelessWidget {
  const _CoinDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CoinDetailCubit, CoinDetailState>(
          builder: (context, state) {
            if (state is CoinDetailLoading) {
              return const CoinDetailSkeleton();
            }

            if (state is CoinDetailError) {
              return Center(child: Text(state.message));
            }

            if (state is CoinDetailLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    const CoinDetailAppBar(),
                    SizedBox(height: 24.h),
                    const CoinDetailPriceSection(),
                    SizedBox(height: 24.h),
                    const CoinDetailRangeSelector(),
                    SizedBox(height: 8.h),
                    const CoinDetailChart(),
                    SizedBox(height: 24.h),
                    const CoinDetailStatsGrid(),
                    SizedBox(height: 24.h),
                    const CoinDetailActionButtons(),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
