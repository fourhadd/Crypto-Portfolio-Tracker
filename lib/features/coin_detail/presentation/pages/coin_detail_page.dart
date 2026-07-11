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
import '../../../../core/shared/widgets/core_network_error_view.dart';

class CoinDetailPage extends StatelessWidget {
  final String coinId;

  /// The CoinEntity the user just tapped on (from Home/Market/Watchlist/
  /// Portfolio), if the caller has one on hand. Passing it in lets the
  /// cubit render that exact price immediately instead of fetching a
  /// second, independent snapshot from `/coins/{id}` that may not match.
  final CoinEntity? initialCoin;

  const CoinDetailPage({super.key, required this.coinId, this.initialCoin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<CoinDetailCubit>()..loadCoin(coinId, initialCoin: initialCoin),
      child: _CoinDetailView(coinId: coinId, initialCoin: initialCoin),
    );
  }
}

class _CoinDetailView extends StatelessWidget {
  final String coinId;
  final CoinEntity? initialCoin;

  const _CoinDetailView({required this.coinId, this.initialCoin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocSelector<CoinDetailCubit, CoinDetailState, Type>(
          selector: (state) => state.runtimeType,
          builder: (context, _) {
            final state = context.read<CoinDetailCubit>().state;

            if (state is CoinDetailLoading) {
              return const CoinDetailSkeleton();
            }

            if (state is CoinDetailError) {
              return CoreNetworkErrorView(
                message: state.message,
                onRetry: () => context.read<CoinDetailCubit>().loadCoin(
                  coinId,
                  initialCoin: initialCoin,
                ),
              );
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
