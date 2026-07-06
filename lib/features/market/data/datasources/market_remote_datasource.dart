// features/market/data/datasources/market_remote_datasource.dart
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/coin_model.dart';

abstract class CoinRemoteDataSource {
  Future<List<CoinModel>> getTopCoins({
    required String vsCurrency,
    required int page,
    required int perPage,
  });

  Future<List<CoinModel>> searchCoins(String query);
}

class CoinRemoteDataSourceImpl implements CoinRemoteDataSource {
  final DioClient dioClient;

  const CoinRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<CoinModel>> getTopCoins({
    required String vsCurrency,
    required int page,
    required int perPage,
  }) async {
    final response = await dioClient.get(
      ApiConstants.coinsMarkets,
      queryParameters: {
        'vs_currency': vsCurrency,
        'order': 'market_cap_desc',
        'per_page': perPage,
        'page': page,
        'sparkline': false,
        'price_change_percentage': '24h',
      },
    );

    final data = response.data as List;
    return data
        .map((json) => CoinModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CoinModel>> searchCoins(String query) async {
    final response = await dioClient.get(
      ApiConstants.search,
      queryParameters: {'query': query},
    );

    final coinsRaw = (response.data['coins'] as List?) ?? [];
    final ids = coinsRaw.map((c) => c['id'] as String).take(20).join(',');

    if (ids.isEmpty) return [];

    final marketsResponse = await dioClient.get(
      ApiConstants.coinsMarkets,
      queryParameters: {
        'vs_currency': 'usd',
        'ids': ids,
        'sparkline': false,
        'price_change_percentage': '24h',
      },
    );

    final marketsData = marketsResponse.data as List;
    return marketsData
        .map((json) => CoinModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
