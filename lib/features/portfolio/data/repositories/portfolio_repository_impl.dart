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
}
