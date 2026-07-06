// features/coin_detail/data/datasources/coin_detail_remote_datasource.dart
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/chart_point_entity.dart';
import '../models/coin_detail_model.dart';
import '../models/chart_point_model.dart';

abstract class CoinDetailRemoteDataSource {
  Future<CoinDetailModel> getCoinDetail({
    required String coinId,
    required String vsCurrency,
  });

  Future<List<ChartPointModel>> getCoinChart({
    required String coinId,
    required ChartRange range,
    required String vsCurrency,
  });
}

class CoinDetailRemoteDataSourceImpl implements CoinDetailRemoteDataSource {
  final DioClient dioClient;

  CoinDetailRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CoinDetailModel> getCoinDetail({
    required String coinId,
    required String vsCurrency,
  }) async {
    final response = await dioClient.get(
      ApiConstants.coinDetail(coinId),
      queryParameters: {
        'localization': false,
        'tickers': false,
        'market_data': true,
        'community_data': false,
        'developer_data': false,
        'sparkline': true,
      },
    );

    return CoinDetailModel.fromJson(response.data, vsCurrency: vsCurrency);
  }

  @override
  Future<List<ChartPointModel>> getCoinChart({
    required String coinId,
    required ChartRange range,
    required String vsCurrency,
  }) async {
    final response = await dioClient.get(
      ApiConstants.coinMarketChart(coinId),
      queryParameters: {'vs_currency': vsCurrency, 'days': range.daysParam},
    );

    return ChartPointModel.listFromJson(response.data);
  }
}
