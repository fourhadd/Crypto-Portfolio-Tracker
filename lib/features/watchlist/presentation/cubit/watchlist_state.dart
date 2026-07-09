import 'package:equatable/equatable.dart';

import '../../domain/entities/watchlist_coin_entity.dart';

enum WatchlistStatus { initial, loading, loaded, error }

class WatchlistState extends Equatable {
  final WatchlistStatus status;
  final List<WatchlistCoinEntity> coins;
  final String? errorMessage;

  const WatchlistState({
    this.status = WatchlistStatus.initial,
    this.coins = const [],
    this.errorMessage,
  });

  bool get isEmpty => coins.isEmpty;
  bool get isLoading => status == WatchlistStatus.loading;

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<WatchlistCoinEntity>? coins,
    String? errorMessage,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, coins, errorMessage];
}
