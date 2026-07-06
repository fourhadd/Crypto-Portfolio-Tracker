// features/market/data/models/coin_model.dart
import '../../domain/entities/coin_entity.dart';

class CoinModel extends CoinEntity {
  const CoinModel({
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
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      currentPrice: _toDouble(json['current_price']),
      marketCap: _toDouble(json['market_cap']),
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      totalVolume: _toDouble(json['total_volume']),
      priceChangePercentage24h: _toDouble(json['price_change_percentage_24h']),
      high24h: json['high_24h'] != null ? _toDouble(json['high_24h']) : null,
      low24h: json['low_24h'] != null ? _toDouble(json['low_24h']) : null,
      circulatingSupply: json['circulating_supply'] != null
          ? _toDouble(json['circulating_supply'])
          : null,
      totalSupply: json['total_supply'] != null
          ? _toDouble(json['total_supply'])
          : null,
      ath: json['ath'] != null ? _toDouble(json['ath']) : null,
      atl: json['atl'] != null ? _toDouble(json['atl']) : null,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
