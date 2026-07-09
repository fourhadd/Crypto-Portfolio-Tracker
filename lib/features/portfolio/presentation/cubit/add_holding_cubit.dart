import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';

import '../../domain/usecases/add_holding_usecase.dart';
import 'add_holding_state.dart';

class AddHoldingCubit extends Cubit<AddHoldingState> {
  final AddHoldingUseCase addHoldingUseCase;

  AddHoldingCubit({required this.addHoldingUseCase})
    : super(AddHoldingState.initial());

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
          errorMessage: 'error in add holding time',
        ),
      );
    }
  }
}
