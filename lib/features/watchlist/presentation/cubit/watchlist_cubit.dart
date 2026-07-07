// features/watchlist/presentation/cubit/watchlist_cubit.dart
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
  }) : super(const WatchlistInitial());

  void startWatching({String vsCurrency = 'usd'}) {
    emit(const WatchlistLoading());

    _subscription?.cancel();
    _subscription = watchWatchlistCoins(vsCurrency: vsCurrency).listen(
      (result) {
        result.fold(
          (failure) => emit(WatchlistError(failure.message)),
          (coins) => emit(WatchlistLoaded(coins)),
        );
      },
      onError: (_) {
        emit(const WatchlistError('Naməlum xəta baş verdi'));
      },
    );
  }

  Future<void> removeCoin(String coinId) async {
    final current = state;
    if (current is WatchlistLoaded) {
      final optimistic = current.coins
          .where((item) => item.coin.id != coinId)
          .toList();
      emit(WatchlistLoaded(optimistic));
    }

    await removeFromWatchlist(coinId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
