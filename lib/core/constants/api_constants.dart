// core/constants/api_constants.dart
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  static const String demoApiKey =
      'your_demo_api_key_here'; // Replace with your actual demo API key if needed

  static const String coinsMarkets = '/coins/markets';

  static const String search = '/search';

  static String coinDetail(String id) => '/coins/$id';

  static String coinMarketChart(String id) => '/coins/$id/market_chart';

  static const String simplePrice = '/simple/price';

  static const String supportedVsCurrencies = '/simple/supported_vs_currencies';

  static const int requestTimeoutSeconds = 15;
}
