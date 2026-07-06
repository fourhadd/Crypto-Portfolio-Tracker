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
      final remoteCoins = await remoteDataSource.getTopCoins(
        vsCurrency: vsCurrency,
        page: page,
        perPage: perPage,
      );
      return Right(remoteCoins);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is NetworkException) {
        return const Left(NetworkFailure());
      } else if (e is TimeoutException) {
        return const Left(TimeoutFailure());
      }
      return const Left(UnknownFailure());
    }
  }
}
