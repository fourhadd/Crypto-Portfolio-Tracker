import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_portfolio_tracker/core/shared/cubit/connectivity_cubit.dart';

import '../../domain/usecases/sell_holding_usecase.dart';
import 'sell_holding_state.dart';

class SellHoldingCubit extends Cubit<SellHoldingState> {
  final SellHoldingUseCase sellHoldingUseCase;
  final ConnectivityCubit connectivityCubit;
  final String holdingId;
  final double maxAmount;

  SellHoldingCubit({
    required this.sellHoldingUseCase,
    required this.connectivityCubit,
    required this.holdingId,
    required this.maxAmount,
  }) : super(const SellHoldingState());

  void setAmount(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.')) ?? 0;
    final clamped = parsed.clamp(0, maxAmount).toDouble();
    emit(state.copyWith(sellAmount: clamped));
  }

  void setPercent(double percent) {
    emit(state.copyWith(sellAmount: maxAmount * percent));
  }

  Future<void> submit() async {
    if (state.sellAmount <= 0 || state.sellAmount > maxAmount) return;
    if (state.isSubmitting) return;

    emit(state.copyWith(status: SellHoldingStatus.submitting));

    // Re-check right before submitting so a stale "online" status from a
    // few seconds ago doesn't let the sale through.
    await connectivityCubit.checkNow();
    if (connectivityCubit.state == ConnectivityStatus.offline) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: SellHoldingStatus.failure,
          errorMessage:
              'No internet connection. Please check your Wi-Fi/mobile data and try again.',
        ),
      );
      return;
    }

    try {
      await sellHoldingUseCase(
        holdingId: holdingId,
        sellAmount: state.sellAmount,
      );
      if (isClosed) return;
      emit(state.copyWith(status: SellHoldingStatus.success));
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: SellHoldingStatus.failure,
          errorMessage: 'Failed to sell holding. Please try again.',
        ),
      );
    }
  }
}
