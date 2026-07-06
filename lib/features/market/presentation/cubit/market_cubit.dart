// features/market/presentation/cubit/market_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/entities/coin_entity.dart';
import '../../../../core/domain/usecases/get_top_coins_usecase.dart';
import 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  final GetTopCoinsUseCase getTopCoins;

  String searchQuery = '';
  List<CoinEntity> _allCoins = [];

  MarketCubit(this.getTopCoins) : super(const MarketInitial());

  String get currentFilter =>
      state is MarketLoaded ? (state as MarketLoaded).currentFilter : 'All';
  double? get minPrice =>
      state is MarketLoaded ? (state as MarketLoaded).minPrice : null;
  double? get maxPrice =>
      state is MarketLoaded ? (state as MarketLoaded).maxPrice : null;

  Future<void> fetchMarkets({String vsCurrency = 'usd'}) async {
    emit(const MarketLoading());

    final result = await getTopCoins(
      vsCurrency: vsCurrency,
      page: 1,
      perPage: 100,
    );

    result.fold((failure) => emit(MarketError(failure.message)), (coins) {
      _allCoins = coins;
      emit(MarketLoaded(_getFilteredCoins()));
    });
  }

  Future<void> refreshMarkets({String vsCurrency = 'usd'}) async {
    final result = await getTopCoins(
      vsCurrency: vsCurrency,
      page: 1,
      perPage: 100,
    );

    result.fold((failure) => emit(MarketError(failure.message)), (coins) {
      _allCoins = coins;

      final prevFilter = currentFilter;
      final prevMin = minPrice;
      final prevMax = maxPrice;

      emit(
        MarketLoaded(
          _getFilteredCoins(filter: prevFilter, min: prevMin, max: prevMax),
          currentFilter: prevFilter,
          minPrice: prevMin,
          maxPrice: prevMax,
        ),
      );
    });
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    if (state is MarketLoaded) {
      final s = state as MarketLoaded;
      emit(
        s.copyWith(
          coins: _getFilteredCoins(
            filter: s.currentFilter,
            min: s.minPrice,
            max: s.maxPrice,
          ),
        ),
      );
    }
  }

  void changeFilter(String newFilter) {
    if (state is! MarketLoaded) return;
    final s = state as MarketLoaded;
    if (s.currentFilter == newFilter) return;

    emit(
      s.copyWith(
        currentFilter: newFilter,
        coins: _getFilteredCoins(
          filter: newFilter,
          min: s.minPrice,
          max: s.maxPrice,
        ),
      ),
    );
  }

  void applyAdvancedFilters({double? minPrice, double? maxPrice}) {
    if (state is! MarketLoaded) return;
    final s = state as MarketLoaded;

    emit(
      s.copyWith(
        minPrice: minPrice,
        maxPrice: maxPrice,
        clearMinPrice: minPrice == null,
        clearMaxPrice: maxPrice == null,
        coins: _getFilteredCoins(
          filter: s.currentFilter,
          min: minPrice,
          max: maxPrice,
        ),
      ),
    );
  }

  void resetFilters() {
    if (state is! MarketLoaded) return;
    final s = state as MarketLoaded;

    emit(
      s.copyWith(
        clearMinPrice: true,
        clearMaxPrice: true,
        coins: _getFilteredCoins(filter: s.currentFilter, min: null, max: null),
      ),
    );
  }

  bool get hasActiveFilters => minPrice != null || maxPrice != null;

  List<CoinEntity> _getFilteredCoins({
    String? filter,
    double? min,
    double? max,
  }) {
    final activeFilter = filter ?? currentFilter;
    final activeMin = min ?? this.minPrice;
    final activeMax = max ?? this.maxPrice;

    List<CoinEntity> list = List.from(_allCoins);

    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      list = list
          .where(
            (coin) =>
                coin.name.toLowerCase().contains(query) ||
                coin.symbol.toLowerCase().contains(query),
          )
          .toList();
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
}
