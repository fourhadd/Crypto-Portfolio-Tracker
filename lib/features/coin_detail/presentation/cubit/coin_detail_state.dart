import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../domain/entities/coin_detail_entity.dart';
import '../../domain/entities/chart_point_entity.dart';

List<FlSpot> _spotsFor(List<ChartPointEntity> points) => <FlSpot>[
  for (var i = 0; i < points.length; i++)
    FlSpot(i.toDouble(), points[i].price),
];

abstract class CoinDetailState extends Equatable {
  const CoinDetailState();

  @override
  List<Object?> get props => [];
}

class CoinDetailLoading extends CoinDetailState {
  const CoinDetailLoading();
}

class CoinDetailError extends CoinDetailState {
  final String message;
  const CoinDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class CoinDetailLoaded extends CoinDetailState {
  final CoinDetailEntity coin;
  final ChartRange selectedRange;
  final List<ChartPointEntity> chartPoints;
  final bool isChartLoading;
  final bool isInWatchlist;
  // Fix #25: precomputed once per chartPoints change instead of being
  // rebuilt from scratch inside _Chart.build() on every rebuild.
  final List<FlSpot> chartSpots;

  CoinDetailLoaded({
    required this.coin,
    required this.selectedRange,
    required this.chartPoints,
    this.isChartLoading = false,
    this.isInWatchlist = false,
    List<FlSpot>? chartSpots,
  }) : chartSpots = chartSpots ?? _spotsFor(chartPoints);

  CoinDetailLoaded copyWith({
    CoinDetailEntity? coin,
    ChartRange? selectedRange,
    List<ChartPointEntity>? chartPoints,
    bool? isChartLoading,
    bool? isInWatchlist,
  }) {
    final newChartPoints = chartPoints ?? this.chartPoints;
    return CoinDetailLoaded(
      coin: coin ?? this.coin,
      selectedRange: selectedRange ?? this.selectedRange,
      chartPoints: newChartPoints,
      isChartLoading: isChartLoading ?? this.isChartLoading,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      chartSpots: chartPoints == null ? this.chartSpots : _spotsFor(newChartPoints),
    );
  }

  @override
  List<Object?> get props => [
    coin,
    selectedRange,
    chartPoints,
    isChartLoading,
    isInWatchlist,
  ];
}
