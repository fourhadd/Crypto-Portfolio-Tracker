// features/market/presentation/cubit/market_state.dart
import 'package:equatable/equatable.dart';
import '../../../../core/domain/entities/coin_entity.dart';

enum MarketStatus { initial, loading, loaded, error }

class MarketState extends Equatable {
  final MarketStatus status;
  final List<CoinEntity> coins;
  final List<CoinEntity> allCoins;
  final String searchQuery;
  final String currentFilter;
  final double? minPrice;
  final double? maxPrice;
  final String? errorMessage;

  final DateTime? lastFetchedAt;

  const MarketState({
    this.status = MarketStatus.initial,
    this.coins = const [],
    this.allCoins = const [],
    this.searchQuery = '',
    this.currentFilter = 'All',
    this.minPrice,
    this.maxPrice,
    this.errorMessage,
    this.lastFetchedAt,
  });

  bool get isLoading => status == MarketStatus.loading;
  bool get hasActiveFilters => minPrice != null || maxPrice != null;

  MarketState copyWith({
    MarketStatus? status,
    List<CoinEntity>? coins,
    List<CoinEntity>? allCoins,
    String? searchQuery,
    String? currentFilter,
    double? minPrice,
    double? maxPrice,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    String? errorMessage,
    DateTime? lastFetchedAt,
  }) {
    return MarketState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      allCoins: allCoins ?? this.allCoins,
      searchQuery: searchQuery ?? this.searchQuery,
      currentFilter: currentFilter ?? this.currentFilter,
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      errorMessage: errorMessage ?? this.errorMessage,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
    );
  }

  @override
  List<Object?> get props => [
    status,
    coins,
    allCoins,
    searchQuery,
    currentFilter,
    minPrice,
    maxPrice,
    errorMessage,
    lastFetchedAt,
  ];
}
