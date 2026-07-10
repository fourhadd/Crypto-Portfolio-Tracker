// features/home/presentation/cubit/home_cubit.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../market/presentation/cubit/market_cubit.dart';
import '../../../market/presentation/cubit/market_state.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MarketCubit marketCubit;
  static const int _topCount = 10;

  late final StreamSubscription<MarketState> _marketSubscription;

  DateTime? _lastSeenFetchedAt;

  HomeCubit(this.marketCubit) : super(const HomeState()) {
    _emitFromMarket(marketCubit.state);
    _marketSubscription = marketCubit.stream.listen(_emitFromMarket);
    marketCubit.fetchIfNeeded();
  }

  void _emitFromMarket(MarketState marketState) {
    switch (marketState.status) {
      case MarketStatus.initial:
        break;
      case MarketStatus.loading:
        if (state.coins.isEmpty) {
          emit(state.copyWith(status: HomeStatus.loading));
        }
        break;
      case MarketStatus.loaded:
        final fetchedAt = marketState.lastFetchedAt;
        final isFreshFetch =
            fetchedAt != null && fetchedAt != _lastSeenFetchedAt;

        if (isFreshFetch) _lastSeenFetchedAt = fetchedAt;

        emit(
          state.copyWith(
            status: HomeStatus.loaded,
            coins: marketState.allCoins.take(_topCount).toList(),
            lastUpdated: isFreshFetch ? fetchedAt : state.lastUpdated,
          ),
        );
        break;
      case MarketStatus.error:
        if (state.coins.isEmpty) {
          emit(
            state.copyWith(
              status: HomeStatus.error,
              errorMessage: marketState.errorMessage,
            ),
          );
        }
        break;
    }
  }

  Future<void> fetchTopCoins() => marketCubit.fetchIfNeeded();

  @override
  Future<void> close() async {
    await _marketSubscription.cancel();
    return super.close();
  }
}
