import 'package:equatable/equatable.dart';

import '../../domain/entities/portfolio_coin_entity.dart';

enum PortfolioStatus { initial, loading, loaded, error }

class PortfolioState extends Equatable {
  final PortfolioStatus status;
  final List<PortfolioCoinEntity> items;
  final String? errorMessage;

  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  bool get isEmpty => items.isEmpty;
  bool get isLoading => status == PortfolioStatus.loading;

  double get totalValue =>
      items.fold(0.0, (sum, item) => sum + item.currentValue);

  double get totalInvested =>
      items.fold(0.0, (sum, item) => sum + item.investedValue);

  double get totalProfitLoss => totalValue - totalInvested;

  double get totalProfitLossPercent =>
      totalInvested == 0 ? 0 : (totalProfitLoss / totalInvested) * 100;

  double get todayChangeAmount => items.fold(
    0.0,
    (sum, item) =>
        sum + item.currentValue * (item.coin.priceChangePercentage24h / 100),
  );

  double get todayChangePercent {
    final yesterdayValue = totalValue - todayChangeAmount;
    return yesterdayValue == 0
        ? 0.0
        : (todayChangeAmount / yesterdayValue) * 100;
  }

  PortfolioState copyWith({
    PortfolioStatus? status,
    List<PortfolioCoinEntity>? items,
    String? errorMessage,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
