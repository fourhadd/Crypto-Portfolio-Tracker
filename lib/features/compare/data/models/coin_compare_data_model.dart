// features/compare/data/models/coin_compare_data_model.dart
import 'package:crypto_portfolio_tracker/features/compare/domain/entities/coin_compare_data.dart';
import 'package:crypto_portfolio_tracker/features/compare/domain/entities/compare_chart_point.dart';
import 'compare_chart_point_model.dart';

class CoinCompareDataModel extends CoinCompareData {
  const CoinCompareDataModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.imageUrl,
    required super.currentPrice,
    required super.priceChangePercentage24h,
    required super.marketCap,
    required super.totalVolume24h,
    required super.chartPoints,
  });

  factory CoinCompareDataModel.fromJson({
    required Map<String, dynamic> marketJson,
    required Map<String, dynamic> chartJson,
  }) {
    final List<dynamic> rawPrices = chartJson['prices'] as List<dynamic>? ?? [];

    final List<CompareChartPoint> points = rawPrices
        .map((e) => CompareChartPointModel.fromRaw(e as List<dynamic>))
        .toList();

    return CoinCompareDataModel(
      id: marketJson['id'] as String,
      symbol: (marketJson['symbol'] as String).toUpperCase(),
      name: marketJson['name'] as String,
      imageUrl: marketJson['image'] as String? ?? '',
      currentPrice: (marketJson['current_price'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24h:
          (marketJson['price_change_percentage_24h'] as num?)?.toDouble() ??
          0.0,
      marketCap: (marketJson['market_cap'] as num?)?.toDouble() ?? 0.0,
      totalVolume24h: (marketJson['total_volume'] as num?)?.toDouble() ?? 0.0,
      chartPoints: points,
    );
  }
}
