// features/coin_detail/domain/usecases/get_coin_chart_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/chart_point_entity.dart';
import '../repositories/coin_detail_repository.dart';

class GetCoinChartUseCase {
  final CoinDetailRepository repository;

  GetCoinChartUseCase(this.repository);

  Future<Either<Failure, List<ChartPointEntity>>> call({
    required String coinId,
    required ChartRange range,
    String vsCurrency = 'usd',
  }) {
    return repository.getCoinChart(
      coinId: coinId,
      range: range,
      vsCurrency: vsCurrency,
    );
  }
}
