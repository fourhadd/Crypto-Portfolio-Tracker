// features/compare/domain/repositories/compare_repository.dart
import 'package:crypto_portfolio_tracker/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/compare_result.dart';

abstract class CompareRepository {
  Future<Either<Failure, CompareResult>> compareCoins({
    required String firstCoinId,
    required String secondCoinId,
    required String days,
    String vsCurrency,
  });
}
