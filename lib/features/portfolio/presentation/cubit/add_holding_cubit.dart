// features/portfolio/presentation/cubit/add_holding_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';
import 'package:crypto_portfolio_tracker/core/shared/cubit/connectivity_cubit.dart';

import '../../domain/usecases/add_holding_usecase.dart';
import 'add_holding_state.dart';

class AddHoldingCubit extends Cubit<AddHoldingState> {
  final AddHoldingUseCase addHoldingUseCase;
  final ConnectivityCubit connectivityCubit;

  AddHoldingCubit({
    required this.addHoldingUseCase,
    required this.connectivityCubit,
  }) : super(AddHoldingState.initial());

  void selectCoin(CoinEntity coin) {
    emit(state.copyWith(coin: coin, buyPrice: coin.currentPrice));
  }

  void updateQuantity(String value) {
    emit(state.copyWith(quantity: double.tryParse(value.replaceAll(',', '.'))));
  }

  void updateBuyPrice(String value) {
    emit(state.copyWith(buyPrice: double.tryParse(value.replaceAll(',', '.'))));
  }

  void updateBuyDate(DateTime date) {
    emit(state.copyWith(buyDate: date));
  }

  Future<void> submit() async {
    if (!state.isValid || state.isSubmitting) return;

    emit(state.copyWith(status: AddHoldingStatus.submitting));

    await connectivityCubit.checkNow();
    if (connectivityCubit.state == ConnectivityStatus.offline) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AddHoldingStatus.failure,
          errorMessage:
              'No internet connection. Please check your Wi-Fi/mobile data and try again.',
        ),
      );
      return;
    }

    try {
      await addHoldingUseCase(
        coinId: state.coin!.id,
        amount: state.quantity!,
        buyPrice: state.buyPrice!,
        buyDate: state.buyDate,
      );
      if (isClosed) return;
      emit(state.copyWith(status: AddHoldingStatus.success));
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AddHoldingStatus.failure,
          errorMessage: 'Failed to add holding. Please try again.',
        ),
      );
    }
  }
}
