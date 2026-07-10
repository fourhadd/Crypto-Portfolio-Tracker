import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<CoinEntity> coins;
  final String? errorMessage;
  // Debug/verification aid: timestamp of the last successful fetch
  // (including silent auto-refresh ticks), so the UI can show the user
  // that the list really is refreshing in the background.
  final DateTime? lastUpdated;

  const HomeState({
    this.status = HomeStatus.initial,
    this.coins = const [],
    this.errorMessage,
    this.lastUpdated,
  });

  bool get isLoading => status == HomeStatus.loading;
  bool get isLoaded => status == HomeStatus.loaded;
  bool get hasError => status == HomeStatus.error;

  HomeState copyWith({
    HomeStatus? status,
    List<CoinEntity>? coins,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return HomeState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      errorMessage: errorMessage ?? this.errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [status, coins, errorMessage, lastUpdated];
}
