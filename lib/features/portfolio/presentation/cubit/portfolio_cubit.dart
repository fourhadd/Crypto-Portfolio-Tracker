// features/portfolio/presentation/cubit/portfolio_cubit.dart
import 'dart:async';

import 'package:crypto_portfolio_tracker/core/sevices/currency_notifier_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/domain/entities/coin_entity.dart';
import '../../../../core/domain/repositories/coin_repository.dart';
import '../../../../core/sevices/storage_service.dart';
import '../../../market/presentation/cubit/market_cubit.dart';
import '../../../market/presentation/cubit/market_state.dart';
import '../../domain/entities/holding_entity.dart';
import '../../domain/entities/portfolio_coin_entity.dart';
import '../../domain/usecases/add_holding_usecase.dart';
import '../../domain/usecases/remove_holding_usecase.dart';
import '../../domain/usecases/watch_portfolio_holdings_usecase.dart';
import 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  final WatchPortfolioHoldingsUseCase watchPortfolioHoldings;
  final AddHoldingUseCase addHoldingUseCase;
  final RemoveHoldingUseCase removeHoldingUseCase;
  final CoinRepository coinRepository;
  final MarketCubit marketCubit;
  final StorageService storageService;

  StreamSubscription<List<HoldingEntity>>? _holdingsSubscription;
  StreamSubscription<MarketState>? _marketSubscription;
  late final StreamSubscription<String> _currencySubscription;

  List<HoldingEntity> _latestHoldings = const [];
  String _currency = 'usd';

  bool _isRecomputing = false;
  bool _recomputeQueued = false;

  PortfolioCubit({
    required this.watchPortfolioHoldings,
    required this.addHoldingUseCase,
    required this.removeHoldingUseCase,
    required this.coinRepository,
    required this.marketCubit,
    required this.storageService,
    required CurrencyNotifierService currencyNotifier,
  }) : super(const PortfolioState()) {
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

    emit(state.copyWith(status: PortfolioStatus.loading));

    _holdingsSubscription?.cancel();
    _marketSubscription?.cancel();

    _holdingsSubscription = watchPortfolioHoldings().listen(
      (holdings) {
        if (isClosed) return;
        _latestHoldings = holdings;
        _recompute();
      },
      onError: (e, st) {
        if (isClosed) return;

        if (kDebugMode) {
          debugPrint('PORTFOLIO STREAM ERROR: $e');
          debugPrint('STACK TRACE: $st');
        }

        emit(
          state.copyWith(
            status: PortfolioStatus.error,
            errorMessage: 'An unknown error occurred',
          ),
        );
      },
    );
    _marketSubscription = marketCubit.stream.listen((_) => _recompute());

    marketCubit.fetchIfNeeded(vsCurrency: _currency);
  }

  Future<void> _recompute() async {
    if (_latestHoldings.isEmpty) {
      emit(state.copyWith(status: PortfolioStatus.loaded, items: const []));
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

      final missingIds = _latestHoldings
          .map((holding) => holding.coinId)
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

        fetchedById = fallbackResult.fold((failure) {
          if (kDebugMode) {
            debugPrint('PORTFOLIO FALLBACK FAILURE: ${failure.message}');
          }
          return const {};
        }, (coins) => {for (final coin in coins) coin.id: coin});
      }

      final byId = {...marketById, ...fetchedById};

      final items = <PortfolioCoinEntity>[
        for (final holding in _latestHoldings)
          if (byId.containsKey(holding.coinId))
            PortfolioCoinEntity(holding: holding, coin: byId[holding.coinId]!),
      ];

      if (isClosed) return;
      emit(state.copyWith(status: PortfolioStatus.loaded, items: items));
    } finally {
      _isRecomputing = false;
      if (_recomputeQueued) {
        _recomputeQueued = false;
        unawaited(_recompute());
      }
    }
  }

  Future<void> addHolding({
    required String coinId,
    required double amount,
    required double buyPrice,
    required DateTime buyDate,
  }) async {
    await addHoldingUseCase(
      coinId: coinId,
      amount: amount,
      buyPrice: buyPrice,
      buyDate: buyDate,
    );
  }

  Future<void> removeHolding(String holdingId) async {
    if (state.status == PortfolioStatus.loaded) {
      final optimistic = state.items
          .where((item) => item.holding.id != holdingId)
          .toList();

      emit(state.copyWith(items: optimistic));
    }

    await removeHoldingUseCase(holdingId);
  }

  @override
  Future<void> close() async {
    await _holdingsSubscription?.cancel();
    await _marketSubscription?.cancel();
    await _currencySubscription.cancel();
    return super.close();
  }
}
