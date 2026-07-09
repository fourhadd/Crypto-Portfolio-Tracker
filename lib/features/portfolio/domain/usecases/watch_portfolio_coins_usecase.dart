// features/portfolio/domain/usecases/watch_portfolio_coins_usecase.dart
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/domain/repositories/coin_repository.dart';
import '../../../../core/errors/failures.dart';
import '../entities/portfolio_coin_entity.dart';
import '../repositories/portfolio_repository.dart';

class WatchPortfolioCoinsUseCase {
  final PortfolioRepository portfolioRepository;
  final CoinRepository coinRepository;

  WatchPortfolioCoinsUseCase({
    required this.portfolioRepository,
    required this.coinRepository,
  });

  Stream<Either<Failure, List<PortfolioCoinEntity>>> call({
    String vsCurrency = 'usd',
  }) async* {
    await for (final holdings in portfolioRepository.watchHoldings()) {
      if (holdings.isEmpty) {
        yield const Right([]);
        continue;
      }

      final ids = holdings.map((h) => h.coinId).toSet().toList();
      final coinsResult = await coinRepository.getCoinsByIds(
        ids: ids,
        vsCurrency: vsCurrency,
      );

      yield coinsResult.fold((failure) => Left(failure), (coins) {
        final items = <PortfolioCoinEntity>[];
        for (final holding in holdings) {
          final coin = coins.firstWhereOrNull((c) => c.id == holding.coinId);
          if (coin != null) {
            items.add(PortfolioCoinEntity(holding: holding, coin: coin));
          }
        }
        return Right(items);
      });
    }
  }
}
