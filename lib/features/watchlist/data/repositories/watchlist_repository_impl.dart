// features/watchlist/data/repositories/watchlist_repository_impl.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/watchlist_item_entity.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_local_datasource.dart';
import '../models/watchlist_item_model.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<WatchlistItemEntity>>> getWatchlist() async {
    try {
      return Right(localDataSource.getWatchlist());
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addToWatchlist(String coinId) async {
    try {
      final items = localDataSource.getWatchlist();

      final alreadyExists = items.any((item) => item.coinId == coinId);
      if (!alreadyExists) {
        items.add(WatchlistItemModel(coinId: coinId, addedAt: DateTime.now()));
        await localDataSource.saveWatchlist(items);
      }

      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFromWatchlist(String coinId) async {
    try {
      final items = localDataSource.getWatchlist();
      items.removeWhere((item) => item.coinId == coinId);
      await localDataSource.saveWatchlist(items);

      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Stream<Either<Failure, List<WatchlistItemEntity>>> watchWatchlist() {
    return localDataSource
        .watchWatchlist()
        .map<Either<Failure, List<WatchlistItemEntity>>>(
          (items) => Right(items),
        );
  }

  @override
  Future<Either<Failure, bool>> isCoinWatchlisted(String coinId) async {
    try {
      final items = localDataSource.getWatchlist();
      return Right(items.any((item) => item.coinId == coinId));
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
