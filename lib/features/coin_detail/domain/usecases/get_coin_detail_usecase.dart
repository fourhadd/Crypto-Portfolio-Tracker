// features/coin_detail/domain/usecases/get_coin_detail_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/coin_detail_entity.dart';
import '../repositories/coin_detail_repository.dart';

class GetCoinDetailUseCase {
  final CoinDetailRepository repository;

  GetCoinDetailUseCase(this.repository);

  Future<Either<Failure, CoinDetailEntity>> call({
    required String coinId,
    String vsCurrency = 'usd',
  }) {
    return repository.getCoinDetail(coinId: coinId, vsCurrency: vsCurrency);
  }
}
