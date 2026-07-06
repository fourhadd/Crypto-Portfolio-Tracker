// features/watchlist/data/models/watchlist_item_model.dart
import '../../domain/entities/watchlist_item_entity.dart';

class WatchlistItemModel extends WatchlistItemEntity {
  const WatchlistItemModel({required super.coinId, required super.addedAt});

  factory WatchlistItemModel.fromJson(Map<String, dynamic> json) {
    return WatchlistItemModel(
      coinId: json['coinId'] as String? ?? '',
      addedAt:
          DateTime.tryParse(json['addedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'coinId': coinId, 'addedAt': addedAt.toIso8601String()};
  }
}
