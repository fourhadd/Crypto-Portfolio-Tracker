// features/portfolio/domain/usecases/add_holding_usecase.dart
import '../entities/holding_entity.dart';
import '../repositories/portfolio_repository.dart';

class AddHoldingUseCase {
  final PortfolioRepository repository;

  AddHoldingUseCase(this.repository);

  Future<void> call({
    required String coinId,
    required double amount,
    required double buyPrice,
    required DateTime buyDate,
  }) {
    final holding = HoldingEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      coinId: coinId,
      amount: amount,
      buyPrice: buyPrice,
      buyDate: buyDate,
    );
    return repository.addHolding(holding);
  }
}
