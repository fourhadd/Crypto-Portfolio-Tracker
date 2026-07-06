// features/coin_detail/domain/repositories/coin_detail_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/coin_detail_entity.dart';
import '../entities/chart_point_entity.dart';

abstract class CoinDetailRepository {
  Future<Either<Failure, CoinDetailEntity>> getCoinDetail({
    required String coinId,
    String vsCurrency = 'usd',
  });

  Future<Either<Failure, List<ChartPointEntity>>> getCoinChart({
    required String coinId,
    required ChartRange range,
    String vsCurrency = 'usd',
  });
}
