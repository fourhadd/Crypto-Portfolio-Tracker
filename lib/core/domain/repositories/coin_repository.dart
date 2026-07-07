// core/domain/repositories/coin_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/coin_entity.dart';
import '../../errors/failures.dart';

abstract class CoinRepository {
  Future<Either<Failure, List<CoinEntity>>> getTopCoins({
    required String vsCurrency,
    int page = 1,
    int perPage = 100,
  });

  Future<Either<Failure, List<CoinEntity>>> getCoinsByIds({
    required List<String> ids,
    required String vsCurrency,
  });
}
