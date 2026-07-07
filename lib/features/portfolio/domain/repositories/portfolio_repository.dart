// features/portfolio/domain/repositories/portfolio_repository.dart
import '../entities/holding_entity.dart';

abstract class PortfolioRepository {
  Future<List<HoldingEntity>> getHoldings();

  Stream<List<HoldingEntity>> watchHoldings();

  Future<void> addHolding(HoldingEntity holding);

  Future<void> removeHolding(String holdingId);
}
