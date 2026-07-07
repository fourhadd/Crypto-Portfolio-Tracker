// features/compare/data/datasources/compare_remote_datasource.dart
import 'package:crypto_portfolio_tracker/core/network/dio_client.dart';
import 'package:crypto_portfolio_tracker/core/constants/api_constants.dart';
import '../models/coin_compare_data_model.dart';

abstract class CompareRemoteDataSource {
  Future<CoinCompareDataModel> getCoinCompareData({
    required String coinId,
    required String days,
    required String vsCurrency,
  });
}

class CompareRemoteDataSourceImpl implements CompareRemoteDataSource {
  final DioClient dioClient;

  CompareRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CoinCompareDataModel> getCoinCompareData({
    required String coinId,
    required String days,
    required String vsCurrency,
  }) async {
    final marketResponse = await dioClient.dio.get(
      ApiConstants.coinsMarkets,
      queryParameters: {'vs_currency': vsCurrency, 'ids': coinId},
    );

    final List<dynamic> marketList = marketResponse.data as List<dynamic>;
    if (marketList.isEmpty) {
      throw Exception('Coin market data tapılmadı: $coinId');
    }
    final Map<String, dynamic> marketJson =
        marketList.first as Map<String, dynamic>;

    final chartResponse = await dioClient.dio.get(
      ApiConstants.coinMarketChart(coinId),
      queryParameters: {'vs_currency': vsCurrency, 'days': days},
    );

    final Map<String, dynamic> chartJson =
        chartResponse.data as Map<String, dynamic>;

    return CoinCompareDataModel.fromJson(
      marketJson: marketJson,
      chartJson: chartJson,
    );
  }
}
