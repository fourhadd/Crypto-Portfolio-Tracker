// features/coin_detail/presentation/pages/coin_detail_page.dart
import 'package:crypto_portfolio_tracker/core/di/injection_container.dart';
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';
import 'package:crypto_portfolio_tracker/features/coin_detail/domain/entities/coin_detail_entity_mapper.dart';
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
        // Fix #1: previously a single BlocBuilder wrapped the whole page,
        // so every emission (chart range change, isChartLoading toggle,
        // watchlist star) rebuilt the entire scroll view — including the
        // chart. We only need to rebuild here when the state *type*
        // changes (Loading -> Loaded -> Error); the child widgets below
        // already have their own scoped BlocBuilder/buildWhen for their
        // specific fields.
        child: BlocSelector<CoinDetailCubit, CoinDetailState, Type>(
          selector: (state) => state.runtimeType,
          builder: (context, _) {
            final state = context.read<CoinDetailCubit>().state;

            if (state is CoinDetailLoading) {
              return const CoinDetailSkeleton();
            }

            if (state is CoinDetailError) {
              return Center(child: Text(state.message));
            }

            if (state is CoinDetailLoaded) {
              return _LoadedBody(coin: state.coin.toCoinEntity());
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  final CoinEntity coin;

  const _LoadedBody({required this.coin});

  @override
  Widget build(BuildContext context) {
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
          CoinDetailActionButtons(coin: coin),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
