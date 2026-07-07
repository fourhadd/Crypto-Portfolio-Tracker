// features/watchlist/domain/entities/watchlist_coin_entity.dart
import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/coin_entity.dart';

class WatchlistCoinEntity extends Equatable {
  final CoinEntity coin;
  final DateTime addedAt;

  const WatchlistCoinEntity({required this.coin, required this.addedAt});

  @override
  List<Object?> get props => [coin, addedAt];
}
