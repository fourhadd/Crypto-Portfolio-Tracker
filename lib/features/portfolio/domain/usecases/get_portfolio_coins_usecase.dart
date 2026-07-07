// features/portfolio/domain/usecases/get_portfolio_coins_usecase.dart
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/domain/repositories/coin_repository.dart';
import '../../../../core/errors/failures.dart';
import '../entities/portfolio_coin_entity.dart';
import '../repositories/portfolio_repository.dart';

class GetPortfolioCoinsUseCase {
  final PortfolioRepository portfolioRepository;
  final CoinRepository coinRepository;

  GetPortfolioCoinsUseCase({
    required this.portfolioRepository,
    required this.coinRepository,
  });

  Future<Either<Failure, List<PortfolioCoinEntity>>> call({
    String vsCurrency = 'usd',
  }) async {
    final holdings = await portfolioRepository.getHoldings();
    if (holdings.isEmpty) return const Right([]);

    final coinsResult = await coinRepository.getTopCoins(
      vsCurrency: vsCurrency,
    );

    return coinsResult.fold((failure) => Left(failure), (coins) {
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
