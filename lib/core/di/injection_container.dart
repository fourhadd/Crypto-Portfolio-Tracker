// core/di/injection_container.dart
import 'package:crypto_portfolio_tracker/core/sevices/currency_notifier_service.dart';
import 'package:crypto_portfolio_tracker/core/sevices/refresh_interval_notifier_service.dart';
import 'package:crypto_portfolio_tracker/core/sevices/notification_service.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_cubit.dart';
import 'package:crypto_portfolio_tracker/features/composition/presentation/cubit/composition_mode_cubit.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/data/datasources/portfolio_local_datasource.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/domain/usecases/add_holding_usecase.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/domain/usecases/remove_holding_usecase.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/domain/usecases/sell_holding_usecase.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/domain/usecases/watch_portfolio_holdings_usecase.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/presentation/cubit/add_holding_cubit.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:crypto_portfolio_tracker/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:crypto_portfolio_tracker/features/watchlist/data/datasources/watchlist_local_datasource.dart';
import 'package:crypto_portfolio_tracker/features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:crypto_portfolio_tracker/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:crypto_portfolio_tracker/features/watchlist/domain/usecases/is_coin_watchlisted_usecase.dart';
import 'package:crypto_portfolio_tracker/features/watchlist/domain/usecases/watch_watchlist_ids_usecase.dart';
import 'package:crypto_portfolio_tracker/features/watchlist/presentation/cubit/watchlist_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto_portfolio_tracker/core/sevices/storage_service.dart';
import 'package:crypto_portfolio_tracker/core/network/dio_client.dart';
import 'package:crypto_portfolio_tracker/core/data/datasources/coin_remote_datasource.dart';
import 'package:crypto_portfolio_tracker/core/data/repositories/coin_repository_impl.dart';
import 'package:crypto_portfolio_tracker/core/domain/repositories/coin_repository.dart';
import 'package:crypto_portfolio_tracker/core/domain/usecases/get_top_coins_usecase.dart';
import 'package:crypto_portfolio_tracker/features/home/presentation/cubit/home_cubit.dart';
import 'package:crypto_portfolio_tracker/features/market/presentation/cubit/market_cubit.dart';
import 'package:crypto_portfolio_tracker/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:crypto_portfolio_tracker/features/coin_detail/data/datasources/coin_detail_remote_datasource.dart';
import 'package:crypto_portfolio_tracker/features/coin_detail/data/repositories/coin_detail_repository_impl.dart';
import 'package:crypto_portfolio_tracker/features/coin_detail/domain/repositories/coin_detail_repository.dart';
import 'package:crypto_portfolio_tracker/features/coin_detail/domain/usecases/get_coin_detail_usecase.dart';
import 'package:crypto_portfolio_tracker/features/coin_detail/domain/usecases/get_coin_chart_usecase.dart';
import 'package:crypto_portfolio_tracker/features/coin_detail/presentation/cubit/coin_detail_cubit.dart';
import 'package:crypto_portfolio_tracker/features/watchlist/domain/usecases/add_to_watchlist_usecase.dart';
import 'package:crypto_portfolio_tracker/features/watchlist/domain/usecases/remove_from_watchlist_usecase.dart';
import 'package:crypto_portfolio_tracker/features/compare/data/datasources/compare_remote_datasource.dart';
import 'package:crypto_portfolio_tracker/features/compare/data/repositories/compare_repository_impl.dart';
import 'package:crypto_portfolio_tracker/features/compare/domain/repositories/compare_repository.dart';
import 'package:crypto_portfolio_tracker/features/compare/domain/usecases/get_compare_chart_usecase.dart';
import 'package:crypto_portfolio_tracker/features/compare/presentation/cubit/compare_cubit.dart';
import 'package:crypto_portfolio_tracker/core/shared/cubit/connectivity_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<ConnectivityCubit>(() => ConnectivityCubit());
  sl.registerLazySingleton<CurrencyNotifierService>(
    () => CurrencyNotifierService(),
  );
  sl.registerLazySingleton<RefreshIntervalNotifierService>(
    () => RefreshIntervalNotifierService(),
  );
  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  // ===== Market feature =====
  sl.registerLazySingleton<CoinRemoteDataSource>(
    () => CoinRemoteDataSourceImpl(dioClient: sl()),
  );

  sl.registerLazySingleton<CoinRepository>(
    () => CoinRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetTopCoinsUseCase>(() => GetTopCoinsUseCase(sl()));

  // ===== Coin Detail feature =====
  sl.registerLazySingleton<CoinDetailRemoteDataSource>(
    () => CoinDetailRemoteDataSourceImpl(dioClient: sl()),
  );

  sl.registerLazySingleton<CoinDetailRepository>(
    () => CoinDetailRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetCoinDetailUseCase>(
    () => GetCoinDetailUseCase(sl()),
  );

  sl.registerLazySingleton<GetCoinChartUseCase>(
    () => GetCoinChartUseCase(sl()),
  );

  // ===== Watchlist feature =====
  sl.registerLazySingleton<WatchlistLocalDataSource>(
    () => WatchlistLocalDataSourceImpl(storageService: sl()),
  );

  sl.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<AddToWatchlistUseCase>(
    () => AddToWatchlistUseCase(sl()),
  );

  sl.registerLazySingleton<RemoveFromWatchlistUseCase>(
    () => RemoveFromWatchlistUseCase(sl()),
  );

  sl.registerLazySingleton<IsCoinWatchlistedUseCase>(
    () => IsCoinWatchlistedUseCase(sl()),
  );

  sl.registerLazySingleton<WatchWatchlistIdsUseCase>(
    () => WatchWatchlistIdsUseCase(watchlistRepository: sl()),
  );
  sl.registerFactory<WatchlistCubit>(
    () => WatchlistCubit(
      watchWatchlistIds: sl<WatchWatchlistIdsUseCase>(),
      removeFromWatchlist: sl<RemoveFromWatchlistUseCase>(),
      coinRepository: sl<CoinRepository>(),
      marketCubit: sl<MarketCubit>(),
      storageService: sl<StorageService>(),
      currencyNotifier: sl<CurrencyNotifierService>(),
    ),
  );

  // ===== Compare feature =====
  sl.registerLazySingleton<CompareRemoteDataSource>(
    () => CompareRemoteDataSourceImpl(dioClient: sl()),
  );

  sl.registerLazySingleton<CompareRepository>(
    () => CompareRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetCompareChartUseCase>(
    () => GetCompareChartUseCase(sl()),
  );
  // ===== Portfolio feature =====
  sl.registerLazySingleton<PortfolioLocalDataSource>(
    () => PortfolioLocalDataSourceImpl(storageService: sl()),
  );

  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<AddHoldingUseCase>(() => AddHoldingUseCase(sl()));

  sl.registerLazySingleton<RemoveHoldingUseCase>(
    () => RemoveHoldingUseCase(sl()),
  );

  sl.registerLazySingleton<WatchPortfolioHoldingsUseCase>(
    () => WatchPortfolioHoldingsUseCase(portfolioRepository: sl()),
  );

  sl.registerLazySingleton<PortfolioCubit>(
    () => PortfolioCubit(
      watchPortfolioHoldings: sl<WatchPortfolioHoldingsUseCase>(),
      addHoldingUseCase: sl<AddHoldingUseCase>(),
      removeHoldingUseCase: sl<RemoveHoldingUseCase>(),
      coinRepository: sl<CoinRepository>(),
      marketCubit: sl<MarketCubit>(),
      storageService: sl<StorageService>(),
      currencyNotifier: sl<CurrencyNotifierService>(),
    ),
  );
  sl.registerFactory<AddHoldingCubit>(
    () => AddHoldingCubit(
      addHoldingUseCase: sl(),
      connectivityCubit: sl<ConnectivityCubit>(),
    ),
  );
  sl.registerLazySingleton<SellHoldingUseCase>(() => SellHoldingUseCase(sl()));
  // ===== Composition feature =====
  sl.registerFactory<CompositionModeCubit>(() => CompositionModeCubit());

  // ===== Cubits (Factory) =====
  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(storageService: sl()),
  );

  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<MarketCubit>()));
  sl.registerLazySingleton<MarketCubit>(
    () => MarketCubit(
      sl<GetTopCoinsUseCase>(),
      sl<StorageService>(),
      sl<CurrencyNotifierService>(),
      sl<RefreshIntervalNotifierService>(),
    ),
  );

  sl.registerFactory<CoinDetailCubit>(
    () => CoinDetailCubit(
      getCoinDetail: sl(),
      getCoinChart: sl(),
      isCoinWatchlisted: sl(),
      addToWatchlist: sl(),
      removeFromWatchlist: sl(),
    ),
  );

  sl.registerFactory<CompareCubit>(() => CompareCubit(getCompareChart: sl()));
  sl.registerFactory(
    () => SettingsCubit(
      storageService: sl(),
      currencyNotifier: sl(),
      refreshIntervalNotifier: sl(),
    ),
  );

  // ===== Price Alerts feature =====
  sl.registerLazySingleton<PriceAlertsCubit>(
    () => PriceAlertsCubit(
      storageService: sl(),
      marketCubit: sl<MarketCubit>(),
      notificationService: sl(),
    ),
  );
}
