// features/market/domain/usecases/get_top_coins_usecase.dart
import 'package:crypto_portfolio_tracker/features/market/domain/repositories/market_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/coin_entity.dart';

class GetTopCoins {
  final CoinRepository repository;

  const GetTopCoins(this.repository);

  Future<Either<Failure, List<CoinEntity>>> call({
    required String vsCurrency,
    int page = 1,
    int perPage = 100,
  }) {
    return repository.getTopCoins(
      vsCurrency: vsCurrency,
      page: page,
      perPage: perPage,
    );
  }
}
