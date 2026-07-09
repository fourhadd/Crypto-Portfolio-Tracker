import 'dart:async';

import 'package:crypto_portfolio_tracker/core/sevices/currency_notifier_service.dart';
import 'package:crypto_portfolio_tracker/core/sevices/refresh_interval_notifier_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/usecases/get_top_coins_usecase.dart';
import '../../../../core/sevices/storage_service.dart';
import '../../../../core/constants/app_constants.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTopCoinsUseCase getTopCoins;
  final StorageService storageService;

  late final StreamSubscription<String> _currencySubscription;
  late final StreamSubscription<int> _refreshIntervalSubscription;
  Timer? _autoRefreshTimer;

  HomeCubit(
    this.getTopCoins,
    this.storageService,
    CurrencyNotifierService currencyNotifier,
    RefreshIntervalNotifierService refreshIntervalNotifier,
  ) : super(const HomeState()) {
    _currencySubscription = currencyNotifier.stream.listen((currency) {
      fetchTopCoins(vsCurrency: currency);
    });

    _refreshIntervalSubscription = refreshIntervalNotifier.stream.listen((
      seconds,
    ) {
      _startAutoRefresh(seconds);
    });

    _startAutoRefresh(_currentRefreshIntervalSeconds());
  }

  int _currentRefreshIntervalSeconds() {
    return storageService.readValue<int>(
          AppConstants.storageKeyRefreshInterval,
        ) ??
        30;
  }

  void _startAutoRefresh(int seconds) {
    _autoRefreshTimer?.cancel();
    if (seconds <= 0) return;

    _autoRefreshTimer = Timer.periodic(Duration(seconds: seconds), (_) {
      _refreshTopCoinsQuietly();
    });
  }

  Future<void> fetchTopCoins({String? vsCurrency}) async {
    final currency =
        vsCurrency ??
        storageService.readValue<String>(AppConstants.storageKeyCurrency) ??
        'usd';

    emit(state.copyWith(status: HomeStatus.loading));

    final result = await getTopCoins(vsCurrency: currency, perPage: 10);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (coins) => emit(state.copyWith(status: HomeStatus.loaded, coins: coins)),
    );
  }

  /// Same as [fetchTopCoins] but doesn't flip the state to loading, so a
  /// background auto-refresh tick doesn't flash a skeleton/spinner over
  /// data the user is already looking at.
  Future<void> _refreshTopCoinsQuietly() async {
    final currency =
        storageService.readValue<String>(AppConstants.storageKeyCurrency) ??
        'usd';

    final result = await getTopCoins(vsCurrency: currency, perPage: 10);

    if (isClosed) return;

    result.fold(
      (_) {
        // Silent failure - keep showing the last good data, try again
        // on the next tick.
      },
      (coins) => emit(state.copyWith(status: HomeStatus.loaded, coins: coins)),
    );
  }

  @override
  Future<void> close() async {
    _autoRefreshTimer?.cancel();
    await _currencySubscription.cancel();
    await _refreshIntervalSubscription.cancel();
    return super.close();
  }
}
