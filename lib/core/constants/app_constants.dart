// core/constants/app_constants.dart
class AppConstants {
  AppConstants._();

  static const Duration refreshInterval = Duration(seconds: 60);

  static const List<String> supportedCurrencies = ['usd', 'eur', 'azn'];

  static const String defaultCurrency = 'usd';

  static const Map<String, String> chartRanges = {
    '1G': '1',
    '7G': '7',
    '30G': '30',
    '1İL': '365',
  };

  static const String storageKeyTransactions = 'transactions';
  static const String storageKeyWatchlist = 'watchlist_coin_ids';
  static const String storageKeyAlerts = 'alerts';
  static const String storageKeyCurrency = 'selected_currency';
  static const String storageKeyThemeMode = 'theme_mode';
  static const String storageKeyOnboardingSeen = 'onboarding_seen';
}
