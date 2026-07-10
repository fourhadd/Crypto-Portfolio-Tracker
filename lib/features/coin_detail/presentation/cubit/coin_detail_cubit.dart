// features/coin_detail/presentation/cubit/coin_detail_cubit.dart
import 'package:crypto_portfolio_tracker/features/coin_detail/domain/entities/chart_point_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/entities/coin_entity.dart';
import '../../domain/entities/coin_detail_entity_mapper.dart';
import '../../domain/usecases/get_coin_detail_usecase.dart';
import '../../domain/usecases/get_coin_chart_usecase.dart';
import '../../../watchlist/domain/usecases/is_coin_watchlisted_usecase.dart';
import '../../../watchlist/domain/usecases/add_to_watchlist_usecase.dart';
import '../../../watchlist/domain/usecases/remove_from_watchlist_usecase.dart';
import 'coin_detail_state.dart';

class CoinDetailCubit extends Cubit<CoinDetailState> {
  final GetCoinDetailUseCase getCoinDetail;
  final GetCoinChartUseCase getCoinChart;
  final IsCoinWatchlistedUseCase isCoinWatchlisted;
  final AddToWatchlistUseCase addToWatchlist;
  final RemoveFromWatchlistUseCase removeFromWatchlist;

  CoinDetailCubit({
    required this.getCoinDetail,
    required this.getCoinChart,
    required this.isCoinWatchlisted,
    required this.addToWatchlist,
    required this.removeFromWatchlist,
  }) : super(const CoinDetailLoading());

  /// Renders [initialCoin]'s price immediately when provided, and keeps
  /// using its price fields permanently rather than overwriting them
  /// with the background `/coins/{id}` fetch — only supplementary
  /// fields (ATH/ATL, supply, rank) come from that fetch.
  Future<void> loadCoin(String coinId, {CoinEntity? initialCoin}) async {
    const initialRange = ChartRange.twentyFourHour;
    final pinnedCoin = (initialCoin != null && initialCoin.id == coinId)
        ? initialCoin
        : null;

    if (pinnedCoin != null) {
      emit(
        CoinDetailLoaded(
          coin: pinnedCoin.toCoinDetailEntity(),
          selectedRange: initialRange,
          chartPoints: const [],
          isChartLoading: true,
          isInWatchlist: false,
        ),
      );
    } else {
      emit(const CoinDetailLoading());
    }

    final coinResult = await getCoinDetail(coinId: coinId);
    if (isClosed) return;

    await coinResult.fold(
      (failure) async {
        // If we already have a pinned Loaded state from initialCoin,
        // keep showing it rather than replacing good data with an error.
        if (state is! CoinDetailLoaded) emit(CoinDetailError(failure.message));
      },
      (fetchedDetail) async {
        // Only take supplementary fields from the fresh fetch when we
        // have a pinned coin; otherwise use it as-is (cold open, e.g.
        // deep link / price alert tap with no list context).
        final coin = pinnedCoin == null
            ? fetchedDetail
            : pinnedCoin.toCoinDetailEntity().copyWithSupplementalStats(
                fetchedDetail,
              );

        final chartResult = await getCoinChart(
          coinId: coinId,
          range: initialRange,
        );
        if (isClosed) return;

        final watchlistedResult = await isCoinWatchlisted(coinId);
        if (isClosed) return;

        final isInWatchlist = watchlistedResult.fold(
          (failure) => false,
          (value) => value,
        );

        chartResult.fold(
          (failure) {
            if (state is! CoinDetailLoaded) {
              emit(CoinDetailError(failure.message));
            }
          },
          (points) => emit(
            CoinDetailLoaded(
              coin: coin,
              selectedRange: initialRange,
              chartPoints: points,
              isInWatchlist: isInWatchlist,
            ),
          ),
        );
      },
    );
  }

  Future<void> changeRange(ChartRange range) async {
    final current = state;
    if (current is! CoinDetailLoaded) return;
    if (current.selectedRange == range) return;

    final updatingState = current.copyWith(
      selectedRange: range,
      isChartLoading: true,
    );
    emit(updatingState);

    final result = await getCoinChart(coinId: current.coin.id, range: range);
    if (isClosed) return;

    result.fold(
      (failure) => emit(updatingState.copyWith(isChartLoading: false)),
      (points) => emit(
        updatingState.copyWith(chartPoints: points, isChartLoading: false),
      ),
    );
  }

  Future<void> toggleWatchlist() async {
    final current = state;
    if (current is! CoinDetailLoaded) return;

    final newValue = !current.isInWatchlist;
    emit(current.copyWith(isInWatchlist: newValue));

    final result = newValue
        ? await addToWatchlist(current.coin.id)
        : await removeFromWatchlist(current.coin.id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(current.copyWith(isInWatchlist: !newValue)),
      (_) {},
    );
  }
}
