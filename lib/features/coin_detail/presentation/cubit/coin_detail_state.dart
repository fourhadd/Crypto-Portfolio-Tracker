// features/coin_detail/presentation/cubit/coin_detail_state.dart
import '../../domain/entities/coin_detail_entity.dart';
import '../../domain/entities/chart_point_entity.dart';

abstract class CoinDetailState {
  const CoinDetailState();
}

class CoinDetailLoading extends CoinDetailState {
  const CoinDetailLoading();
}

class CoinDetailError extends CoinDetailState {
  final String message;
  const CoinDetailError(this.message);
}

class CoinDetailLoaded extends CoinDetailState {
  final CoinDetailEntity coin;
  final ChartRange selectedRange;
  final List<ChartPointEntity> chartPoints;
  final bool isChartLoading;
  final bool isInWatchlist;

  const CoinDetailLoaded({
    required this.coin,
    required this.selectedRange,
    required this.chartPoints,
    this.isChartLoading = false,
    this.isInWatchlist = false,
  });

  CoinDetailLoaded copyWith({
    CoinDetailEntity? coin,
    ChartRange? selectedRange,
    List<ChartPointEntity>? chartPoints,
    bool? isChartLoading,
    bool? isInWatchlist,
  }) {
    return CoinDetailLoaded(
      coin: coin ?? this.coin,
      selectedRange: selectedRange ?? this.selectedRange,
      chartPoints: chartPoints ?? this.chartPoints,
      isChartLoading: isChartLoading ?? this.isChartLoading,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
    );
  }
}
