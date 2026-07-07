// features/watchlist/presentation/cubit/watchlist_state.dart
import 'package:equatable/equatable.dart';

import '../../domain/entities/watchlist_coin_entity.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistCoinEntity> coins;

  const WatchlistLoaded(this.coins);

  bool get isEmpty => coins.isEmpty;

  @override
  List<Object?> get props => [coins];
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}
