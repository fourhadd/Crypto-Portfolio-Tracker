// features/watchlist/domain/usecases/get_watchlist_coins_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/domain/repositories/coin_repository.dart';
import '../entities/watchlist_coin_entity.dart';
import '../repositories/watchlist_repository.dart';

class GetWatchlistCoinsUseCase {
  final WatchlistRepository watchlistRepository;
  final CoinRepository coinRepository;

  GetWatchlistCoinsUseCase({
    required this.watchlistRepository,
    required this.coinRepository,
  });

  Future<Either<Failure, List<WatchlistCoinEntity>>> call({
    String vsCurrency = 'usd',
  }) async {
    final watchlistResult = await watchlistRepository.getWatchlist();

    if (watchlistResult.isLeft()) {
      return watchlistResult.fold(
        (failure) => Left(failure),
        (_) => const Right(<WatchlistCoinEntity>[]),
      );
    }

    final items = watchlistResult.getOrElse(() => []);

    if (items.isEmpty) {
      return const Right(<WatchlistCoinEntity>[]);
    }

    final ids = items.map((item) => item.coinId).toList();

    final coinsResult = await coinRepository.getCoinsByIds(
      ids: ids,
      vsCurrency: vsCurrency,
    );

    if (coinsResult.isLeft()) {
      return coinsResult.fold(
        (failure) => Left(failure),
        (_) => const Right(<WatchlistCoinEntity>[]),
      );
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

    return Right(merged);
  }
}
