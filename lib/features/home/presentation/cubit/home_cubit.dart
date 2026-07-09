import 'dart:async';

import 'package:crypto_portfolio_tracker/core/sevices/currency_notifier_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/usecases/get_top_coins_usecase.dart';
import '../../../../core/sevices/storage_service.dart';
import '../../../../core/constants/app_constants.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTopCoinsUseCase getTopCoins;
  final StorageService storageService;

  late final StreamSubscription<String> _currencySubscription;

  HomeCubit(
    this.getTopCoins,
    this.storageService,
    CurrencyNotifierService currencyNotifier,
  ) : super(const HomeState()) {
    _currencySubscription = currencyNotifier.stream.listen((currency) {
      fetchTopCoins(vsCurrency: currency);
    });
  }

  Future<void> fetchTopCoins({String? vsCurrency}) async {
    final currency =
        vsCurrency ??
        storageService.readValue<String>(AppConstants.storageKeyCurrency) ??
        'usd';

    emit(state.copyWith(status: HomeStatus.loading));

    final result = await getTopCoins(vsCurrency: currency, perPage: 10);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (coins) => emit(state.copyWith(status: HomeStatus.loaded, coins: coins)),
    );
  }

  @override
  Future<void> close() async {
    await _currencySubscription.cancel();
    return super.close();
  }
}
