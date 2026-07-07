// features/portfolio/domain/usecases/remove_holding_usecase.dart
import '../repositories/portfolio_repository.dart';

class RemoveHoldingUseCase {
  final PortfolioRepository repository;

  RemoveHoldingUseCase(this.repository);

  Future<void> call(String holdingId) => repository.removeHolding(holdingId);
}
