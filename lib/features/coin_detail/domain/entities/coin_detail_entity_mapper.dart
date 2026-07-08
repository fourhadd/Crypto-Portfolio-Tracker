// features/coin_detail/domain/entities/coin_detail_entity_mapper.dart
import '../../../../core/domain/entities/coin_entity.dart';
import 'coin_detail_entity.dart';

extension CoinDetailEntityMapper on CoinDetailEntity {
  CoinEntity toCoinEntity() {
    return CoinEntity(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: currentPrice,
      marketCap: marketCap,
      marketCapRank: marketCapRank,
      totalVolume: totalVolume,
      priceChangePercentage24h: priceChangePercentage24h,
      high24h: high24h,
      low24h: low24h,
      circulatingSupply: circulatingSupply,
      totalSupply: totalSupply,
      ath: ath,
      atl: atl,
      athChangePercentage: athChangePercentage,
      sparkline: sparkline,
    );
  }
}
