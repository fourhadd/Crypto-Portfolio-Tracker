// features/market/presentation/cubit/market_state.dart
import 'package:equatable/equatable.dart';

import '../../domain/entities/coin_entity.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object?> get props => [];
}

class MarketInitial extends MarketState {
  const MarketInitial();
}

class MarketLoading extends MarketState {
  const MarketLoading();
}

class MarketLoaded extends MarketState {
  
  final List<CoinEntity> coins;

  const MarketLoaded(this.coins);

  @override
  List<Object?> get props => [coins];
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object?> get props => [message];
}
