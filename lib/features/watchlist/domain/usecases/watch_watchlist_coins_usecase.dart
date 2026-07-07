// features/watchlist/domain/usecases/watch_watchlist_coins_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/domain/repositories/coin_repository.dart';
import '../entities/watchlist_coin_entity.dart';
import '../repositories/watchlist_repository.dart';

class WatchWatchlistCoinsUseCase {
  final WatchlistRepository watchlistRepository;
  final CoinRepository coinRepository;

  WatchWatchlistCoinsUseCase({
    required this.watchlistRepository,
    required this.coinRepository,
  });

  Stream<Either<Failure, List<WatchlistCoinEntity>>> call({
    String vsCurrency = 'usd',
  }) async* {
    await for (final watchlistResult in watchlistRepository.watchWatchlist()) {
      if (watchlistResult.isLeft()) {
        yield watchlistResult.fold(
          (failure) => Left(failure),
          (_) => const Right(<WatchlistCoinEntity>[]),
        );
        continue;
      }

      final items = watchlistResult.getOrElse(() => []);

      if (items.isEmpty) {
        yield const Right(<WatchlistCoinEntity>[]);
        continue;
      }

      final ids = items.map((item) => item.coinId).toList();

      final coinsResult = await coinRepository.getCoinsByIds(
        ids: ids,
        vsCurrency: vsCurrency,
      );

      if (coinsResult.isLeft()) {
        yield coinsResult.fold(
          (failure) => Left(failure),
          (_) => const Right(<WatchlistCoinEntity>[]),
        );
        continue;
      }

      final coins = coinsResult.getOrElse(() => []);

      final addedAtById = {for (final item in items) item.coinId: item.addedAt};

      final merged =
          coins
              .map(
                (coin) => WatchlistCoinEntity(
                  coin: coin,
                  addedAt: addedAtById[coin.id] ?? DateTime.now(),
                ),
              )
              .toList()
            ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

      yield Right(merged);
    }
  }
}
