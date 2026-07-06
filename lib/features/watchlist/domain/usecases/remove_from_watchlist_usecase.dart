// features/watchlist/domain/usecases/remove_from_watchlist_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/watchlist_repository.dart';

class RemoveFromWatchlistUseCase {
  final WatchlistRepository repository;

  RemoveFromWatchlistUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String coinId) {
    return repository.removeFromWatchlist(coinId);
  }
}
