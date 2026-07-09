import 'dart:async';
import 'package:crypto_portfolio_tracker/core/sevices/currency_notifier_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/sevices/storage_service.dart';
import '../../domain/usecases/remove_from_watchlist_usecase.dart';
import '../../domain/usecases/watch_watchlist_coins_usecase.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final WatchWatchlistCoinsUseCase watchWatchlistCoins;
  final RemoveFromWatchlistUseCase removeFromWatchlist;
  final StorageService storageService;

  StreamSubscription? _subscription;
  late final StreamSubscription<String> _currencySubscription;

  WatchlistCubit({
    required this.watchWatchlistCoins,
    required this.removeFromWatchlist,
    required this.storageService,
    required CurrencyNotifierService currencyNotifier,
  }) : super(const WatchlistState()) {
    _currencySubscription = currencyNotifier.stream.listen((currency) {
      startWatching(vsCurrency: currency);
    });
  }

  void startWatching({String? vsCurrency}) {
    final currency =
        vsCurrency ??
        storageService.readValue<String>(AppConstants.storageKeyCurrency) ??
        'usd';

    emit(state.copyWith(status: WatchlistStatus.loading));

    _subscription?.cancel();

    _subscription = watchWatchlistCoins(vsCurrency: currency).listen(
      (result) {
        if (isClosed) return;

        result.fold(
          (failure) => emit(
            state.copyWith(
              status: WatchlistStatus.error,
              errorMessage: failure.message,
            ),
          ),
          (coins) => emit(
            state.copyWith(status: WatchlistStatus.loaded, coins: coins),
          ),
        );
      },
      onError: (_) {
        if (isClosed) return;

        emit(
          state.copyWith(
            status: WatchlistStatus.error,
            errorMessage: 'Naməlum xəta baş verdi',
          ),
        );
      },
    );
  }

  Future<void> removeCoin(String coinId) async {
    if (state.status == WatchlistStatus.loaded) {
      final optimistic = state.coins
          .where((item) => item.coin.id != coinId)
          .toList();

      emit(state.copyWith(coins: optimistic));
    }

    await removeFromWatchlist(coinId);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _currencySubscription.cancel();
    return super.close();
  }
}
