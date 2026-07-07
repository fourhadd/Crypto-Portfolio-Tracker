// features/portfolio/data/datasources/portfolio_local_datasource.dart
import 'dart:async';

import '../../../../core/local_storage/storage_service.dart';
import '../models/holding_model.dart';

abstract class PortfolioLocalDataSource {
  Future<List<HoldingModel>> getHoldings();

  Stream<List<HoldingModel>> watchHoldings();

  Future<void> addHolding(HoldingModel holding);

  Future<void> removeHolding(String holdingId);
}

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  static const String _storageKey = 'portfolio_holdings';

  final StorageService storageService;
  final StreamController<List<HoldingModel>> _controller =
      StreamController<List<HoldingModel>>.broadcast();

  PortfolioLocalDataSourceImpl({required this.storageService}) {
    _controller.onListen = () async {
      _controller.add(await getHoldings());
    };
  }

  @override
  Future<List<HoldingModel>> getHoldings() async {
    final raw = storageService.readJson(_storageKey);
    if (raw == null) return [];
    return (raw as List)
        .map((e) => HoldingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<HoldingModel>> watchHoldings() => _controller.stream;

  @override
  Future<void> addHolding(HoldingModel holding) async {
    final current = await getHoldings();
    current.add(holding);
    await _persist(current);
  }

  @override
  Future<void> removeHolding(String holdingId) async {
    final current = await getHoldings();
    current.removeWhere((h) => h.id == holdingId);
    await _persist(current);
  }

  Future<void> _persist(List<HoldingModel> holdings) async {
    await storageService.writeJson(
      _storageKey,
      holdings.map((h) => h.toJson()).toList(),
    );
    _controller.add(holdings);
  }
}
