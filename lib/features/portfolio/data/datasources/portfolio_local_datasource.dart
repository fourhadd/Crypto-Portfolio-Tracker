// features/portfolio/data/datasources/portfolio_local_datasource.dart
import 'dart:async';

import '../../../../core/sevices/storage_service.dart';
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

  // Fix #17: cache the latest value so a *second* (and later) subscriber
  // gets the current holdings immediately instead of hanging until the
  // next _persist() call — onListen only fires for the first listener.
  List<HoldingModel>? _latestHoldings;

  PortfolioLocalDataSourceImpl({required this.storageService}) {
    _controller.onListen = () async {
      _latestHoldings ??= await getHoldings();
      _controller.add(_latestHoldings!);
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
  Stream<List<HoldingModel>> watchHoldings() async* {
    _latestHoldings ??= await getHoldings();
    yield _latestHoldings!;
    yield* _controller.stream;
  }

  // Fix #21: consolidate by coinId instead of appending a new lot per
  // purchase. Buying 1 BTC @ 50k then 1 BTC @ 60k now yields a single
  // row: 2 BTC @ weighted-avg 55k — not two separate portfolio rows.
  // This also makes the sell flow (#22) safe, since there is now at
  // most one lot per coinId to sell against.
  @override
  Future<void> addHolding(HoldingModel holding) async {
    final current = await getHoldings();
    final index = current.indexWhere((h) => h.coinId == holding.coinId);

    if (index == -1) {
      current.add(holding);
    } else {
      final existing = current[index];
      final totalAmount = existing.amount + holding.amount;
      final weightedBuyPrice = totalAmount == 0
          ? existing.buyPrice
          : (existing.amount * existing.buyPrice +
                    holding.amount * holding.buyPrice) /
                totalAmount;

      current[index] = HoldingModel(
        id: existing.id,
        coinId: existing.coinId,
        amount: totalAmount,
        buyPrice: weightedBuyPrice,
        // Keep the original purchase date for the consolidated lot.
        buyDate: existing.buyDate,
      );
    }

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
    _latestHoldings = holdings;
    _controller.add(holdings);
  }
}
