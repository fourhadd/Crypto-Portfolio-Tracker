// features/watchlist/domain/entities/watchlist_item_entity.dart
import 'package:equatable/equatable.dart';

class WatchlistItemEntity extends Equatable {
  final String coinId;
  final DateTime addedAt;

  const WatchlistItemEntity({required this.coinId, required this.addedAt});

  @override
  List<Object?> get props => [coinId, addedAt];
}
