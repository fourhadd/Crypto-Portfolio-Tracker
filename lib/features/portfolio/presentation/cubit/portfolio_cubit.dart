// features/portfolio/presentation/cubit/portfolio_cubit.dart
import 'dart:async';

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
  }) : super(const PortfolioInitial());

  void startWatching({String vsCurrency = 'usd'}) {
    emit(const PortfolioLoading());

    _subscription?.cancel();
    _subscription = watchPortfolioCoins(vsCurrency: vsCurrency).listen(
      (result) {
        result.fold(
          (failure) => emit(PortfolioError(failure.message)),
          (items) => emit(PortfolioLoaded(items)),
        );
      },
      onError: (_) {
        emit(const PortfolioError('Naməlum xəta baş verdi'));
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
    final current = state;
    if (current is PortfolioLoaded) {
      final optimistic = current.items
          .where((item) => item.holding.id != holdingId)
          .toList();
      emit(PortfolioLoaded(optimistic));
    }

    await removeHoldingUseCase(holdingId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
