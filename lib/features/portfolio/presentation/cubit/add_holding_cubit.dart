// features/portfolio/presentation/cubit/add_holding_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';

import '../../domain/usecases/add_holding_usecase.dart';
import 'add_holding_state.dart';

class AddHoldingCubit extends Cubit<AddHoldingState> {
  final AddHoldingUseCase addHoldingUseCase;

  AddHoldingCubit({required this.addHoldingUseCase})
    : super(AddHoldingState.initial());

  void selectCoin(CoinEntity coin) {
    emit(
      AddHoldingState(
        coin: coin,
        quantity: state.quantity,
        buyPrice: coin.currentPrice,
        buyDate: state.buyDate,
      ),
    );
  }

  void updateQuantity(String value) {
    emit(
      AddHoldingState(
        coin: state.coin,
        quantity: double.tryParse(value.replaceAll(',', '.')),
        buyPrice: state.buyPrice,
        buyDate: state.buyDate,
      ),
    );
  }

  void updateBuyPrice(String value) {
    emit(
      AddHoldingState(
        coin: state.coin,
        quantity: state.quantity,
        buyPrice: double.tryParse(value.replaceAll(',', '.')),
        buyDate: state.buyDate,
      ),
    );
  }

  void updateBuyDate(DateTime date) {
    emit(
      AddHoldingState(
        coin: state.coin,
        quantity: state.quantity,
        buyPrice: state.buyPrice,
        buyDate: date,
      ),
    );
  }

  Future<void> submit() async {
    if (!state.isValid || state.isSubmitting) return;

    emit(
      AddHoldingState(
        coin: state.coin,
        quantity: state.quantity,
        buyPrice: state.buyPrice,
        buyDate: state.buyDate,
        status: AddHoldingStatus.submitting,
      ),
    );

    try {
      await addHoldingUseCase(
        coinId: state.coin!.id,
        amount: state.quantity!,
        buyPrice: state.buyPrice!,
        buyDate: state.buyDate,
      );
      emit(
        AddHoldingState(
          coin: state.coin,
          quantity: state.quantity,
          buyPrice: state.buyPrice,
          buyDate: state.buyDate,
          status: AddHoldingStatus.success,
        ),
      );
    } catch (_) {
      emit(
        AddHoldingState(
          coin: state.coin,
          quantity: state.quantity,
          buyPrice: state.buyPrice,
          buyDate: state.buyDate,
          status: AddHoldingStatus.failure,
          errorMessage: 'Holding əlavə edilərkən xəta baş verdi',
        ),
      );
    }
  }
}
