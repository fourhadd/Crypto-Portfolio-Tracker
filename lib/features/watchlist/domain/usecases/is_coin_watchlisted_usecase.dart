// features/watchlist/domain/usecases/is_coin_watchlisted_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/watchlist_repository.dart';

class IsCoinWatchlistedUseCase {
  final WatchlistRepository repository;

  IsCoinWatchlistedUseCase(this.repository);

  Future<Either<Failure, bool>> call(String coinId) {
    return repository.isCoinWatchlisted(coinId);
  }
}
