// features/watchlist/domain/usecases/get_watchlist_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/watchlist_item_entity.dart';
import '../repositories/watchlist_repository.dart';

class GetWatchlistUseCase {
  final WatchlistRepository repository;

  GetWatchlistUseCase(this.repository);

  Future<Either<Failure, List<WatchlistItemEntity>>> call() {
    return repository.getWatchlist();
  }
}
