// features/coin_detail/presentation/cubit/coin_detail_cubit.dart
import 'package:crypto_portfolio_tracker/features/coin_detail/domain/entities/chart_point_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_coin_detail_usecase.dart';
import '../../domain/usecases/get_coin_chart_usecase.dart';
import '../../../watchlist/domain/usecases/get_watchlist_usecase.dart';
import '../../../watchlist/domain/usecases/add_to_watchlist_usecase.dart';
import '../../../watchlist/domain/usecases/remove_from_watchlist_usecase.dart';
import 'coin_detail_state.dart';

class CoinDetailCubit extends Cubit<CoinDetailState> {
  final GetCoinDetailUseCase getCoinDetail;
  final GetCoinChartUseCase getCoinChart;
  final GetWatchlistUseCase getWatchlist;
  final AddToWatchlistUseCase addToWatchlist;
  final RemoveFromWatchlistUseCase removeFromWatchlist;

  CoinDetailCubit({
    required this.getCoinDetail,
    required this.getCoinChart,
    required this.getWatchlist,
    required this.addToWatchlist,
    required this.removeFromWatchlist,
  }) : super(const CoinDetailLoading());

  Future<void> loadCoin(String coinId) async {
    emit(const CoinDetailLoading());

    final coinResult = await getCoinDetail(coinId: coinId);
    if (isClosed) return;

    await coinResult.fold(
      (failure) async => emit(CoinDetailError(failure.message)),
      (coin) async {
        const initialRange = ChartRange.twentyFourHour;

        final chartResult = await getCoinChart(
          coinId: coinId,
          range: initialRange,
        );
        if (isClosed) return;

        final watchlistResult = await getWatchlist();
        if (isClosed) return;

        final isInWatchlist = watchlistResult.fold(
          (failure) => false,
          (items) => items.any((item) => item.coinId == coinId),
        );

        chartResult.fold(
          (failure) => emit(CoinDetailError(failure.message)),
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
