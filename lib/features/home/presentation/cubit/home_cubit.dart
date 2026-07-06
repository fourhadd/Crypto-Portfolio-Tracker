// features/home/presentation/cubit/home_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usecases/get_top_coins_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTopCoinsUseCase getTopCoins;

  HomeCubit(this.getTopCoins) : super(const HomeInitial());

  Future<void> fetchTopCoins({String vsCurrency = 'usd'}) async {
    emit(const HomeLoading());

    final result = await getTopCoins(vsCurrency: vsCurrency, perPage: 10);

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (coins) => emit(HomeLoaded(coins)),
    );
  }
}
