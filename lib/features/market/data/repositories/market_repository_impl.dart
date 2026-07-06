// features/market/data/repositories/market_repository_impl.dart
import 'package:crypto_portfolio_tracker/features/market/data/datasources/market_remote_datasource.dart';
import 'package:crypto_portfolio_tracker/features/market/domain/repositories/market_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/coin_entity.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinRemoteDataSource remoteDataSource;

  const CoinRepositoryImpl(this.remoteDataSource);

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
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Naməlum xəta: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CoinEntity>>> searchCoins(String query) async {
    try {
      final coins = await remoteDataSource.searchCoins(query);
      return Right(coins);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Naməlum xəta: $e'));
    }
  }
}
