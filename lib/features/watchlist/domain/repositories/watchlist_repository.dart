// features/watchlist/domain/repositories/watchlist_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/watchlist_item_entity.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<WatchlistItemEntity>>> getWatchlist();

  Future<Either<Failure, Unit>> addToWatchlist(String coinId);

  Future<Either<Failure, Unit>> removeFromWatchlist(String coinId);

  Stream<Either<Failure, List<WatchlistItemEntity>>> watchWatchlist();

  Future<Either<Failure, bool>> isCoinWatchlisted(String coinId);
}
