// features/coin_detail/data/repositories/coin_detail_repository_impl.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/coin_detail_entity.dart';
import '../../domain/entities/chart_point_entity.dart';
import '../../domain/repositories/coin_detail_repository.dart';
import '../datasources/coin_detail_remote_datasource.dart';

class CoinDetailRepositoryImpl implements CoinDetailRepository {
  final CoinDetailRemoteDataSource remoteDataSource;

  CoinDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CoinDetailEntity>> getCoinDetail({
    required String coinId,
    String vsCurrency = 'usd',
  }) async {
    try {
      final model = await remoteDataSource.getCoinDetail(
        coinId: coinId,
        vsCurrency: vsCurrency,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<ChartPointEntity>>> getCoinChart({
    required String coinId,
    required ChartRange range,
    String vsCurrency = 'usd',
  }) async {
    try {
      final points = await remoteDataSource.getCoinChart(
        coinId: coinId,
        range: range,
        vsCurrency: vsCurrency,
      );
      return Right(points);
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  Failure _mapException(Object e) {
    if (e is ServerException) return ServerFailure(e.message);
    if (e is NetworkException) return const NetworkFailure();
    if (e is TimeoutException) return const TimeoutFailure();
    return const UnknownFailure();
  }
}
