// features/watchlist/domain/usecases/add_to_watchlist_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/watchlist_repository.dart';

class AddToWatchlistUseCase {
  final WatchlistRepository repository;

  AddToWatchlistUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String coinId) {
    return repository.addToWatchlist(coinId);
  }
}
