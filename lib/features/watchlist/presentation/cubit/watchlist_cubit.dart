import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/watch_watchlist_coins_usecase.dart';
import '../../domain/usecases/remove_from_watchlist_usecase.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final WatchWatchlistCoinsUseCase watchWatchlistCoins;
  final RemoveFromWatchlistUseCase removeFromWatchlist;

  StreamSubscription? _subscription;

  WatchlistCubit({
    required this.watchWatchlistCoins,
    required this.removeFromWatchlist,
  }) : super(const WatchlistState());

  void startWatching({String vsCurrency = 'usd'}) {
    emit(state.copyWith(status: WatchlistStatus.loading));

    _subscription?.cancel();
    _subscription = watchWatchlistCoins(vsCurrency: vsCurrency).listen(
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
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
