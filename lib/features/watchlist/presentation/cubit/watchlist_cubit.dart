// features/watchlist/presentation/cubit/watchlist_cubit.dart
import 'dart:async';
import 'package:crypto_portfolio_tracker/core/sevices/currency_notifier_service.dart';
import 'package:crypto_portfolio_tracker/features/market/presentation/cubit/market_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/domain/entities/coin_entity.dart';
import '../../../../core/domain/repositories/coin_repository.dart';
import '../../../../core/sevices/storage_service.dart';
import '../../../market/presentation/cubit/market_cubit.dart';
import '../../domain/entities/watchlist_coin_entity.dart';
import '../../domain/entities/watchlist_item_entity.dart';
import '../../domain/usecases/remove_from_watchlist_usecase.dart';
import '../../domain/usecases/watch_watchlist_ids_usecase.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final WatchWatchlistIdsUseCase watchWatchlistIds;
  final RemoveFromWatchlistUseCase removeFromWatchlist;
  final CoinRepository coinRepository;
  final MarketCubit marketCubit;
  final StorageService storageService;

  StreamSubscription<dynamic>? _idsSubscription;
  StreamSubscription<MarketState>? _marketSubscription;
  late final StreamSubscription<String> _currencySubscription;

  List<WatchlistItemEntity> _latestItems = const [];
  String _currency = 'usd';

  bool _isRecomputing = false;
  bool _recomputeQueued = false;

  WatchlistCubit({
    required this.watchWatchlistIds,
    required this.removeFromWatchlist,
    required this.coinRepository,
    required this.marketCubit,
    required this.storageService,
    required CurrencyNotifierService currencyNotifier,
  }) : super(const WatchlistState()) {
    _currencySubscription = currencyNotifier.stream.listen((currency) {
      startWatching(vsCurrency: currency);
    });
  }

  void startWatching({String? vsCurrency}) {
    _currency =
        vsCurrency ??
        storageService
            .readValue<String>(AppConstants.storageKeyCurrency)
            ?.toLowerCase() ??
        'usd';

    emit(state.copyWith(status: WatchlistStatus.loading));

    _idsSubscription?.cancel();
    _marketSubscription?.cancel();

    _idsSubscription = watchWatchlistIds().listen(
      (result) {
        if (isClosed) return;

        result.fold(
          (failure) => emit(
            state.copyWith(
              status: WatchlistStatus.error,
              errorMessage: failure.message,
            ),
          ),
          (items) {
            _latestItems = items;
            _recompute();
          },
        );
      },
      onError: (_) {
        if (isClosed) return;

        emit(
          state.copyWith(
            status: WatchlistStatus.error,
            errorMessage: 'An unknown error occurred',
          ),
        );
      },
    );
    _marketSubscription = marketCubit.stream.listen((_) => _recompute());

    marketCubit.fetchIfNeeded(vsCurrency: _currency);
  }

  Future<void> _recompute() async {
    if (_latestItems.isEmpty) {
      emit(state.copyWith(status: WatchlistStatus.loaded, coins: const []));
      return;
    }

    if (_isRecomputing) {
      _recomputeQueued = true;
      return;
    }
    _isRecomputing = true;

    try {
      final marketById = {
        for (final coin in marketCubit.state.allCoins) coin.id: coin,
      };

      final missingIds = _latestItems
          .map((item) => item.coinId)
          .where((id) => !marketById.containsKey(id))
          .toSet()
          .toList();

      Map<String, CoinEntity> fetchedById = const {};
      if (missingIds.isNotEmpty) {
        final fallbackResult = await coinRepository.getCoinsByIds(
          ids: missingIds,
          vsCurrency: _currency,
        );
        if (isClosed) return;

        fetchedById = fallbackResult.fold(
          (failure) => const {},
          (coins) => {for (final coin in coins) coin.id: coin},
        );
      }

      final byId = {...marketById, ...fetchedById};

      final merged =
          _latestItems
              .where((item) => byId.containsKey(item.coinId))
              .map(
                (item) => WatchlistCoinEntity(
                  coin: byId[item.coinId]!,
                  addedAt: item.addedAt,
                ),
              )
              .toList()
            ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

      if (isClosed) return;
      emit(state.copyWith(status: WatchlistStatus.loaded, coins: merged));
    } finally {
      _isRecomputing = false;
      if (_recomputeQueued) {
        _recomputeQueued = false;
        unawaited(_recompute());
      }
    }
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
    await _idsSubscription?.cancel();
    await _marketSubscription?.cancel();
    await _currencySubscription.cancel();
    return super.close();
  }
}
