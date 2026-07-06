// features/market/presentation/cubit/market_cubit.dart
import 'package:crypto_portfolio_tracker/features/market/domain/usecases/get_top_coins_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  final GetTopCoins getTopCoins;

  MarketCubit(this.getTopCoins) : super(const MarketInitial());

  Future<void> fetchTopCoins({String vsCurrency = 'usd'}) async {
    emit(const MarketLoading());

    final result = await getTopCoins(vsCurrency: vsCurrency);

    result.fold(
      (failure) => emit(MarketError(failure.message)),
      (coins) => emit(MarketLoaded(coins)),
    );
  }
}
