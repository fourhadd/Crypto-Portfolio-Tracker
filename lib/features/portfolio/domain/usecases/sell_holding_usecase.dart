// features/portfolio/domain/usecases/sell_holding_usecase.dart
import '../repositories/portfolio_repository.dart';

class SellHoldingUseCase {
  final PortfolioRepository repository;

  SellHoldingUseCase(this.repository);

  Future<void> call({required String holdingId, required double sellAmount}) {
    return repository.reduceHolding(holdingId, sellAmount);
  }
}
