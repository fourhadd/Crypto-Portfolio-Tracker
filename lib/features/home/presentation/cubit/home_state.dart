import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<CoinEntity> coins;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.coins = const [],
    this.errorMessage,
  });

  bool get isLoading => status == HomeStatus.loading;
  bool get isLoaded => status == HomeStatus.loaded;
  bool get hasError => status == HomeStatus.error;

  HomeState copyWith({
    HomeStatus? status,
    List<CoinEntity>? coins,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, coins, errorMessage];
}
