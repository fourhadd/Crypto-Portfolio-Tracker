// features/market/presentation/cubit/market_state.dart
import 'package:equatable/equatable.dart';
import '../../../../core/domain/entities/coin_entity.dart';

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
  final String currentFilter;
  final double? minPrice;
  final double? maxPrice;

  const MarketLoaded(
    this.coins, {
    this.currentFilter = 'All',
    this.minPrice,
    this.maxPrice,
  });

  MarketLoaded copyWith({
    List<CoinEntity>? coins,
    String? currentFilter,
    double? minPrice,
    double? maxPrice,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
  }) {
    return MarketLoaded(
      coins ?? this.coins,
      currentFilter: currentFilter ?? this.currentFilter,
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
    );
  }

  @override
  List<Object?> get props => [coins, currentFilter, minPrice, maxPrice];
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object?> get props => [message];
}
