// core/domain/usecases/get_top_coins_usecase.dart
import 'package:dartz/dartz.dart';
import '../entities/coin_entity.dart';
import '../repositories/coin_repository.dart';
import '../../errors/failures.dart';

class GetTopCoinsUseCase {
  final CoinRepository repository;

  GetTopCoinsUseCase(this.repository);

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
