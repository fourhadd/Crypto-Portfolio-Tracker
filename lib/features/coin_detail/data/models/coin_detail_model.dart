// features/coin_detail/data/models/coin_detail_model.dart
import '../../domain/entities/coin_detail_entity.dart';

class CoinDetailModel extends CoinDetailEntity {
  const CoinDetailModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.image,
    required super.currentPrice,
    required super.marketCap,
    required super.marketCapRank,
    required super.totalVolume,
    required super.priceChangePercentage24h,
    super.high24h,
    super.low24h,
    super.circulatingSupply,
    super.totalSupply,
    super.ath,
    super.atl,
    super.athChangePercentage,
    required super.sparkline,
  });

  factory CoinDetailModel.fromJson(
    Map<String, dynamic> json, {
    String vsCurrency = 'usd',
  }) {
    final marketData = json['market_data'] as Map<String, dynamic>? ?? {};
    final image = json['image'] as Map<String, dynamic>? ?? {};

    return CoinDetailModel(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      image: image['large'] as String? ?? image['small'] as String? ?? '',
      currentPrice: _currencyValue(marketData['current_price'], vsCurrency),
      marketCap: _currencyValue(marketData['market_cap'], vsCurrency),
      marketCapRank:
          (marketData['market_cap_rank'] as num?)?.toInt() ??
          (json['market_cap_rank'] as num?)?.toInt() ??
          0,
      totalVolume: _currencyValue(marketData['total_volume'], vsCurrency),
      priceChangePercentage24h: _toDouble(
        marketData['price_change_percentage_24h'],
      ),
      athChangePercentage: _currencyValue(
        marketData['ath_change_percentage'],
        vsCurrency,
      ),
      high24h: marketData['high_24h'] != null
          ? _currencyValue(marketData['high_24h'], vsCurrency)
          : null,
      low24h: marketData['low_24h'] != null
          ? _currencyValue(marketData['low_24h'], vsCurrency)
          : null,
      circulatingSupply: marketData['circulating_supply'] != null
          ? _toDouble(marketData['circulating_supply'])
          : null,
      totalSupply: marketData['total_supply'] != null
          ? _toDouble(marketData['total_supply'])
          : null,
      ath: marketData['ath'] != null
          ? _currencyValue(marketData['ath'], vsCurrency)
          : null,
      atl: marketData['atl'] != null
          ? _currencyValue(marketData['atl'], vsCurrency)
          : null,
      sparkline: _parseSparkline(marketData['sparkline_7d']),
    );
  }

  static double _currencyValue(dynamic value, String vsCurrency) {
    if (value is Map) {
      return _toDouble(value[vsCurrency]);
    }
    return _toDouble(value);
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static List<double> _parseSparkline(dynamic sparklineData) {
    if (sparklineData != null && sparklineData['price'] != null) {
      final List<dynamic> prices = sparklineData['price'];
      return prices.map((e) => _toDouble(e)).toList();
    }
    return [];
  }
}
