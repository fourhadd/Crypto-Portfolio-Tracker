// features/compare/domain/usecases/get_compare_chart_usecase.dart
import 'package:crypto_portfolio_tracker/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/compare_result.dart';
import '../repositories/compare_repository.dart';

class GetCompareChartUseCase {
  final CompareRepository repository;

  GetCompareChartUseCase(this.repository);

  Future<Either<Failure, CompareResult>> call({
    required String firstCoinId,
    required String secondCoinId,
    required String days,
    String vsCurrency = 'usd',
  }) {
    return repository.compareCoins(
      firstCoinId: firstCoinId,
      secondCoinId: secondCoinId,
      days: days,
      vsCurrency: vsCurrency,
    );
  }
}
