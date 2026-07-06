// features/market/domain/entities/coin_entity.dart
import 'package:equatable/equatable.dart';

class CoinEntity extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final double totalVolume;
  final double priceChangePercentage24h;
  final double? high24h;
  final double? low24h;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? ath;
  final double? atl;

  const CoinEntity({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.totalVolume,
    required this.priceChangePercentage24h,
    this.high24h,
    this.low24h,
    this.circulatingSupply,
    this.totalSupply,
    this.ath,
    this.atl,
  });

  bool get isPriceUp => priceChangePercentage24h >= 0;

  @override
  List<Object?> get props => [
    id,
    symbol,
    name,
    image,
    currentPrice,
    marketCap,
    marketCapRank,
    totalVolume,
    priceChangePercentage24h,
    high24h,
    low24h,
    circulatingSupply,
    totalSupply,
    ath,
    atl,
  ];
}
