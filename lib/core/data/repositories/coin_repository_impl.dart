// core/data/repositories/coin_repository_impl.dart
import 'package:dartz/dartz.dart';

import '../../errors/exceptions.dart';
import '../../errors/failures.dart';
import '../../domain/entities/coin_entity.dart';
import '../../domain/repositories/coin_repository.dart';
import '../datasources/coin_remote_datasource.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinRemoteDataSource remoteDataSource;

  CoinRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CoinEntity>>> getTopCoins({
    required String vsCurrency,
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final coins = await remoteDataSource.getTopCoins(
        vsCurrency: vsCurrency,
        page: page,
        perPage: perPage,
      );
      return Right(coins);
    } catch (e) {
      return Left(_mapToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CoinEntity>>> getCoinsByIds({
    required List<String> ids,
    required String vsCurrency,
  }) async {
    if (ids.isEmpty) return const Right(<CoinEntity>[]);

    try {
      final coins = await remoteDataSource.getCoinsByIds(
        ids: ids,
        vsCurrency: vsCurrency,
      );
      return Right(coins);
    } catch (e) {
      return Left(_mapToFailure(e));
    }
  }

  // Maps DioClient's already-classified exceptions to the matching
  // Failure type so the UI can distinguish network/timeout/server errors.
  Failure _mapToFailure(Object e) {
    if (e is NetworkException) return NetworkFailure(e.message);
    if (e is TimeoutException) return TimeoutFailure(e.message);
    if (e is ServerException) return ServerFailure(e.message);
    return UnknownFailure(e.toString());
  }
}
