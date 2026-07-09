// features/compare/presentation/cubit/compare_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';
import 'package:crypto_portfolio_tracker/features/compare/domain/entities/compare_coin_ref.dart';
import 'package:crypto_portfolio_tracker/features/compare/domain/usecases/get_compare_chart_usecase.dart';
import 'compare_state.dart';

class CompareCubit extends Cubit<CompareState> {
  final GetCompareChartUseCase getCompareChart;

  CompareCubit({required this.getCompareChart}) : super(const CompareState());

  void selectFirstCoin(CoinEntity coin) {
    emit(
      state.copyWith(
        selectedFirst: CompareCoinRef(
          id: coin.id,
          symbol: coin.symbol,
          image: coin.image,
        ),
        clearResult: true,
        clearError: true,
      ),
    );
    _fetchIfReady();
  }

  void selectSecondCoin(CoinEntity coin) {
    emit(
      state.copyWith(
        selectedSecond: CompareCoinRef(
          id: coin.id,
          symbol: coin.symbol,
          image: coin.image,
        ),
        clearResult: true,
        clearError: true,
      ),
    );
    _fetchIfReady();
  }

  void presetFirstCoinId(String coinId) {
    emit(
      state.copyWith(
        selectedFirst: CompareCoinRef(id: coinId, symbol: '', image: ''),
        clearResult: true,
        clearError: true,
      ),
    );
    _fetchIfReady();
  }

  void presetSecondCoinId(String coinId) {
    emit(
      state.copyWith(
        selectedSecond: CompareCoinRef(id: coinId, symbol: '', image: ''),
        clearResult: true,
        clearError: true,
      ),
    );
    _fetchIfReady();
  }

  void removeFirstCoin() {
    emit(
      state.copyWith(
        clearFirst: true,
        clearResult: true,
        clearError: true,
        status: CompareStatus.idle,
      ),
    );
  }

  void removeSecondCoin() {
    emit(
      state.copyWith(
        clearSecond: true,
        clearResult: true,
        clearError: true,
        status: CompareStatus.idle,
      ),
    );
  }

  Future<void> changeTimeframe(CompareTimeframe timeframe) async {
    if (state.timeframe == timeframe) return;
    emit(state.copyWith(timeframe: timeframe));
    await _fetchIfReady();
  }

  Future<void> refresh() => _fetchIfReady();

  Future<void> _fetchIfReady() async {
    final first = state.selectedFirst;
    final second = state.selectedSecond;
    if (first == null || second == null) return;

    emit(state.copyWith(status: CompareStatus.loading));

    final result = await getCompareChart(
      firstCoinId: first.id,
      secondCoinId: second.id,
      days: state.timeframe.apiValue,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CompareStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (compareResult) => emit(
        state.copyWith(
          status: CompareStatus.loaded,
          result: compareResult,
          clearError: true,

          selectedFirst: CompareCoinRef(
            id: compareResult.first.id,
            symbol: compareResult.first.symbol,
            image: compareResult.first.imageUrl,
          ),
          selectedSecond: CompareCoinRef(
            id: compareResult.second.id,
            symbol: compareResult.second.symbol,
            image: compareResult.second.imageUrl,
          ),
        ),
      ),
    );
  }
}
