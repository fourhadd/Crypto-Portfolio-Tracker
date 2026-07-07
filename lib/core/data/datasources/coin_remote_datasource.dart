// core/data/datasources/coin_remote_datasource.dart
import '../../constants/api_constants.dart';
import '../../network/dio_client.dart';
import '../models/coin_model.dart';

abstract class CoinRemoteDataSource {
  Future<List<CoinModel>> getTopCoins({
    required String vsCurrency,
    int page = 1,
    int perPage = 100,
  });

  Future<List<CoinModel>> getCoinsByIds({
    required List<String> ids,
    required String vsCurrency,
  });
}

class CoinRemoteDataSourceImpl implements CoinRemoteDataSource {
  final DioClient dioClient;

  CoinRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<CoinModel>> getTopCoins({
    required String vsCurrency,
    int page = 1,
    int perPage = 100,
  }) async {
    final response = await dioClient.get(
      ApiConstants.coinsMarkets,
      queryParameters: {
        'vs_currency': vsCurrency,
        'order': 'market_cap_desc',
        'per_page': perPage,
        'page': page,
        'sparkline': true,
        'price_change_percentage': '24h',
      },
    );

    final List<dynamic> data = response.data;
    return data.map((json) => CoinModel.fromJson(json)).toList();
  }

  @override
  Future<List<CoinModel>> getCoinsByIds({
    required List<String> ids,
    required String vsCurrency,
  }) async {
    if (ids.isEmpty) return [];

    final response = await dioClient.get(
      ApiConstants.coinsMarkets,
      queryParameters: {
        'vs_currency': vsCurrency,
        'ids': ids.join(','),
        'order': 'market_cap_desc',
        'sparkline': true,
        'price_change_percentage': '24h',
      },
    );

    final List<dynamic> data = response.data;
    return data.map((json) => CoinModel.fromJson(json)).toList();
  }
}
