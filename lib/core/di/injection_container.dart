// core/di/injection_container.dart
import 'package:crypto_portfolio_tracker/core/local_storage/storage_service.dart';
import 'package:crypto_portfolio_tracker/core/network/dio_client.dart';
import 'package:crypto_portfolio_tracker/features/market/data/datasources/market_remote_datasource.dart';
import 'package:crypto_portfolio_tracker/features/market/data/repositories/market_repository_impl.dart';
import 'package:crypto_portfolio_tracker/features/market/domain/repositories/market_repository.dart';
import 'package:crypto_portfolio_tracker/features/market/domain/usecases/get_top_coins_usecase.dart';
import 'package:crypto_portfolio_tracker/features/market/presentation/cubit/market_cubit.dart';
import 'package:crypto_portfolio_tracker/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<StorageService>(() => StorageService());

  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(storageService: sl()),
  );

  sl.registerLazySingleton<CoinRemoteDataSource>(
    () => CoinRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CoinRepository>(() => CoinRepositoryImpl(sl()));
  sl.registerLazySingleton<GetTopCoins>(() => GetTopCoins(sl()));
  sl.registerFactory<MarketCubit>(() => MarketCubit(sl()));
}
