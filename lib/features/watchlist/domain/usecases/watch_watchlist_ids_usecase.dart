// features/watchlist/domain/usecases/watch_watchlist_ids_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/watchlist_item_entity.dart';
import '../repositories/watchlist_repository.dart';

class WatchWatchlistIdsUseCase {
  final WatchlistRepository watchlistRepository;

  WatchWatchlistIdsUseCase({required this.watchlistRepository});

  Stream<Either<Failure, List<WatchlistItemEntity>>> call() {
    return watchlistRepository.watchWatchlist();
  }
}
