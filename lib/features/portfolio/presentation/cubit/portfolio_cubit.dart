import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_holding_usecase.dart';
import '../../domain/usecases/remove_holding_usecase.dart';
import '../../domain/usecases/watch_portfolio_coins_usecase.dart';
import 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  final WatchPortfolioCoinsUseCase watchPortfolioCoins;
  final AddHoldingUseCase addHoldingUseCase;
  final RemoveHoldingUseCase removeHoldingUseCase;

  StreamSubscription? _subscription;

  PortfolioCubit({
    required this.watchPortfolioCoins,
    required this.addHoldingUseCase,
    required this.removeHoldingUseCase,
  }) : super(const PortfolioState());

  void startWatching({String vsCurrency = 'usd'}) {
    emit(state.copyWith(status: PortfolioStatus.loading));

    _subscription?.cancel();
    _subscription = watchPortfolioCoins(vsCurrency: vsCurrency).listen(
      (result) {
        if (isClosed) return;
        result.fold(
          (failure) {
            if (kDebugMode) {
              debugPrint('PORTFOLIO FAILURE: ${failure.message}');
            }
            emit(
              state.copyWith(
                status: PortfolioStatus.error,
                errorMessage: failure.message,
              ),
            );
          },
          (items) => emit(
            state.copyWith(status: PortfolioStatus.loaded, items: items),
          ),
        );
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
            errorMessage: 'Naməlum xəta baş verdi',
          ),
        );
      },
    );
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
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
