// features/watchlist/data/datasources/watchlist_local_datasource.dart
import 'dart:async';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local_storage/storage_service.dart';
import '../models/watchlist_item_model.dart';

abstract class WatchlistLocalDataSource {
  List<WatchlistItemModel> getWatchlist();

  Future<void> saveWatchlist(List<WatchlistItemModel> items);

  Stream<List<WatchlistItemModel>> watchWatchlist();
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final StorageService storageService;

  WatchlistLocalDataSourceImpl({required this.storageService});

  final StreamController<List<WatchlistItemModel>> _controller =
      StreamController<List<WatchlistItemModel>>.broadcast();

  @override
  List<WatchlistItemModel> getWatchlist() {
    final raw = storageService.readJson(AppConstants.storageKeyWatchlist);
    if (raw == null) return [];

    return (raw as List<dynamic>)
        .map((e) => WatchlistItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveWatchlist(List<WatchlistItemModel> items) async {
    await storageService.writeJson(
      AppConstants.storageKeyWatchlist,
      items.map((e) => e.toJson()).toList(),
    );

    if (!_controller.isClosed) {
      _controller.add(items);
    }
  }

  @override
  Stream<List<WatchlistItemModel>> watchWatchlist() async* {
    yield getWatchlist();
    yield* _controller.stream;
  }
}
