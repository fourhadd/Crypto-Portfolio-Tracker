// features/portfolio/domain/entities/portfolio_coin_entity.dart
import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/coin_entity.dart';
import 'holding_entity.dart';

class PortfolioCoinEntity extends Equatable {
  final HoldingEntity holding;
  final CoinEntity coin;

  const PortfolioCoinEntity({required this.holding, required this.coin});

  double get currentValue => holding.amount * coin.currentPrice;

  double get investedValue => holding.amount * holding.buyPrice;

  double get profitLoss => currentValue - investedValue;

  double get profitLossPercent =>
      investedValue == 0 ? 0 : (profitLoss / investedValue) * 100;

  @override
  List<Object?> get props => [holding, coin];
}
