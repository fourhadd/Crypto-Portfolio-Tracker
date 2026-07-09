import 'dart:async';

import 'package:crypto_portfolio_tracker/core/sevices/currency_notifier_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/domain/entities/coin_entity.dart';
import '../../../../core/domain/usecases/get_top_coins_usecase.dart';
import '../../../../core/sevices/storage_service.dart';
import 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  final GetTopCoinsUseCase getTopCoins;
  final StorageService storageService;

  Timer? _searchDebounce;
  late final StreamSubscription<String> _currencySubscription;

  MarketCubit(
    this.getTopCoins,
    this.storageService,
    CurrencyNotifierService currencyNotifier,
  ) : super(const MarketState()) {
    _currencySubscription = currencyNotifier.stream.listen((currency) {
      refreshMarkets(vsCurrency: currency);
    });
  }

  Future<void> fetchIfNeeded({String? vsCurrency}) async {
    if (state.status == MarketStatus.loaded && state.allCoins.isNotEmpty) {
      return;
    }

    await fetchMarkets(vsCurrency: vsCurrency);
  }

  Future<void> fetchMarkets({String? vsCurrency}) async {
    final currency =
        vsCurrency ??
        storageService.readValue<String>(AppConstants.storageKeyCurrency) ??
        'usd';

    emit(state.copyWith(status: MarketStatus.loading));

    final result = await getTopCoins(
      vsCurrency: currency,
      page: 1,
      perPage: 100,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MarketStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (coins) => emit(
        state.copyWith(
          status: MarketStatus.loaded,
          allCoins: coins,
          coins: _filteredCoins(all: coins),
        ),
      ),
    );
  }

  Future<void> refreshMarkets({String? vsCurrency}) async {
    final currency =
        vsCurrency ??
        storageService.readValue<String>(AppConstants.storageKeyCurrency) ??
        'usd';

    final result = await getTopCoins(
      vsCurrency: currency,
      page: 1,
      perPage: 100,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MarketStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (coins) => emit(
        state.copyWith(
          status: MarketStatus.loaded,
          allCoins: coins,
          coins: _filteredCoins(all: coins),
        ),
      ),
    );
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));

    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (isClosed) return;

      emit(
        state.copyWith(
          coins: _filteredCoins(all: state.allCoins, query: query),
        ),
      );
    });
  }

  void changeFilter(String newFilter) {
    if (state.currentFilter == newFilter) return;

    emit(
      state.copyWith(
        currentFilter: newFilter,
        coins: _filteredCoins(all: state.allCoins, filter: newFilter),
      ),
    );
  }

  void applyAdvancedFilters({double? minPrice, double? maxPrice}) {
    emit(
      state.copyWith(
        minPrice: minPrice,
        maxPrice: maxPrice,
        clearMinPrice: minPrice == null,
        clearMaxPrice: maxPrice == null,
        coins: _filteredCoins(
          all: state.allCoins,
          min: minPrice,
          max: maxPrice,
        ),
      ),
    );
  }

  void resetFilters() {
    emit(
      state.copyWith(
        clearMinPrice: true,
        clearMaxPrice: true,
        coins: _filteredCoins(all: state.allCoins, min: null, max: null),
      ),
    );
  }

  List<CoinEntity> _filteredCoins({
    required List<CoinEntity> all,
    String? query,
    String? filter,
    double? min,
    double? max,
  }) {
    final activeQuery = query ?? state.searchQuery;
    final activeFilter = filter ?? state.currentFilter;
    final activeMin = min ?? state.minPrice;
    final activeMax = max ?? state.maxPrice;

    List<CoinEntity> list = List.from(all);

    if (activeQuery.trim().isNotEmpty) {
      final q = activeQuery.trim().toLowerCase();

      list = list.where((coin) {
        return coin.name.toLowerCase().contains(q) ||
            coin.symbol.toLowerCase().contains(q);
      }).toList();
    }

    if (activeMin != null) {
      list = list.where((coin) => coin.currentPrice >= activeMin).toList();
    }

    if (activeMax != null) {
      list = list.where((coin) => coin.currentPrice <= activeMax).toList();
    }

    switch (activeFilter) {
      case 'Top Gainers':
        list.sort(
          (a, b) =>
              b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h),
        );
        break;

      case 'Top Losers':
        list.sort(
          (a, b) =>
              a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h),
        );
        break;

      case 'Volume':
        list.sort((a, b) => b.totalVolume.compareTo(a.totalVolume));
        break;

      case 'All':
      default:
        break;
    }

    return list;
  }

  @override
  Future<void> close() async {
    _searchDebounce?.cancel();
    await _currencySubscription.cancel();
    return super.close();
  }
}
