// features/portfolio/data/repositories/portfolio_repository_impl.dart
import '../../domain/entities/holding_entity.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_datasource.dart';
import '../models/holding_model.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource localDataSource;

  PortfolioRepositoryImpl({required this.localDataSource});

  @override
  Future<List<HoldingEntity>> getHoldings() => localDataSource.getHoldings();

  @override
  Stream<List<HoldingEntity>> watchHoldings() =>
      localDataSource.watchHoldings();

  @override
  Future<void> addHolding(HoldingEntity holding) =>
      localDataSource.addHolding(HoldingModel.fromEntity(holding));

  @override
  Future<void> removeHolding(String holdingId) =>
      localDataSource.removeHolding(holdingId);

  @override
  Future<void> reduceHolding(String holdingId, double sellAmount) async {
    final holdings = await localDataSource.getHoldings();
    final index = holdings.indexWhere((h) => h.id == holdingId);
    if (index == -1) return;

    final current = holdings[index];
    final remaining = current.amount - sellAmount;

    await localDataSource.removeHolding(holdingId);

    if (remaining > 0.00000001) {
      await localDataSource.addHolding(
        HoldingModel.fromEntity(
          HoldingEntity(
            id: current.id,
            coinId: current.coinId,
            amount: remaining,
            buyPrice: current.buyPrice,
            buyDate: current.buyDate,
          ),
        ),
      );
    }
  }
}
