import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usecases/get_top_coins_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTopCoinsUseCase getTopCoins;

  HomeCubit(this.getTopCoins) : super(const HomeState());

  Future<void> fetchTopCoins({String vsCurrency = 'usd'}) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await getTopCoins(vsCurrency: vsCurrency, perPage: 10);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (coins) => emit(state.copyWith(status: HomeStatus.loaded, coins: coins)),
    );
  }
}
