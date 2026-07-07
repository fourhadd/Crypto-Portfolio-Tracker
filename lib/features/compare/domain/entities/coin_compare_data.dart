// features/compare/domain/entities/coin_compare_data.dart
import 'compare_chart_point.dart';

class CoinCompareData {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final double totalVolume24h;
  final List<CompareChartPoint> chartPoints;

  const CoinCompareData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume24h,
    required this.chartPoints,
  });
}
