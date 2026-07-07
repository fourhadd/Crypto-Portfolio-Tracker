// features/portfolio/presentation/cubit/portfolio_state.dart
import 'package:equatable/equatable.dart';

import '../../domain/entities/portfolio_coin_entity.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

class PortfolioLoaded extends PortfolioState {
  final List<PortfolioCoinEntity> items;

  const PortfolioLoaded(this.items);

  bool get isEmpty => items.isEmpty;

  double get totalValue =>
      items.fold(0.0, (sum, item) => sum + item.currentValue);

  double get totalInvested =>
      items.fold(0.0, (sum, item) => sum + item.investedValue);

  double get totalProfitLoss => totalValue - totalInvested;

  double get totalProfitLossPercent =>
      totalInvested == 0 ? 0 : (totalProfitLoss / totalInvested) * 100;

  @override
  List<Object?> get props => [items];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
