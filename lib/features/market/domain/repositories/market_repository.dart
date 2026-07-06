// features/market/domain/repositories/market_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/coin_entity.dart';

abstract class CoinRepository {
  Future<Either<Failure, List<CoinEntity>>> getTopCoins({
    required String vsCurrency,
    int page = 1,
    int perPage = 100,
  });

  Future<Either<Failure, List<CoinEntity>>> searchCoins(String query);
}
