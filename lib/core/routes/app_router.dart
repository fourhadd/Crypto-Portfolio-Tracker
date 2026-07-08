// core/routes/app_router.dart
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';
import 'package:crypto_portfolio_tracker/core/shared/widgets/main_wrapper.dart';
import 'package:crypto_portfolio_tracker/core/utils/page_transitions.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/presentation/pages/portfolio_page.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/presentation/pages/sell_holding_page.dart';
import 'package:crypto_portfolio_tracker/features/watchlist/presentation/pages/watchlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/market/presentation/cubit/market_cubit.dart';
import '../../features/market/presentation/pages/market_page.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/coin_detail/presentation/pages/coin_detail_page.dart';
import '../../features/compare/presentation/cubit/compare_cubit.dart';
import '../../features/compare/presentation/pages/compare_page.dart';
import '../../features/portfolio/presentation/cubit/add_holding_cubit.dart';
import '../../features/portfolio/presentation/pages/add_holding_page.dart';
import '../../features/composition/presentation/pages/composition_page.dart';
import '../constants/app_constants.dart';
import '../di/injection_container.dart';
import '../local_storage/storage_service.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: _getInitialLocation(),
    routes: [
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => sl<OnboardingCubit>(),
            child: const OnboardingPage(),
          ),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/coin/:coinId',
        pageBuilder: (context, state) {
          final coinId = state.pathParameters['coinId']!;
          return AppTransitions.push(
            state: state,
            child: CoinDetailPage(coinId: coinId),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/compare',
        pageBuilder: (context, state) {
          final firstCoinId = state.uri.queryParameters['first'];
          final secondCoinId = state.uri.queryParameters['second'];

          return AppTransitions.push(
            state: state,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<CompareCubit>(
                  create: (context) {
                    final cubit = sl<CompareCubit>();
                    if (firstCoinId != null) {
                      cubit.presetFirstCoinId(firstCoinId);
                    }
                    if (secondCoinId != null) {
                      cubit.presetSecondCoinId(secondCoinId);
                    }
                    return cubit;
                  },
                ),
                BlocProvider<MarketCubit>(
                  create: (context) => sl<MarketCubit>()..fetchMarkets(),
                ),
              ],
              child: const ComparePage(),
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/portfolio/add',
        pageBuilder: (context, state) {
          // Coin Detail-dən "Buy" ilə gəlirsə, extra-da CoinEntity ötürülür
          // və AddHoldingCubit yaradılan kimi bu coin preset edilir.
          final presetCoin = state.extra is CoinEntity
              ? state.extra as CoinEntity
              : null;

          return AppTransitions.modal(
            state: state,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<AddHoldingCubit>(
                  create: (context) {
                    final cubit = sl<AddHoldingCubit>();
                    if (presetCoin != null) {
                      cubit.selectCoin(presetCoin);
                    }
                    return cubit;
                  },
                ),
                BlocProvider<MarketCubit>(
                  create: (context) => sl<MarketCubit>()..fetchMarkets(),
                ),
              ],
              child: const AddHoldingPage(),
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/portfolio/sell/:coinId',
        pageBuilder: (context, state) {
          final coinId = state.pathParameters['coinId']!;
          // PortfolioCubit app kökündə (app.dart) provide olunub,
          // burada ayrıca yaratmırıq — context.read ilə oxunacaq.
          return AppTransitions.push(
            state: state,
            child: SellHoldingPage(coinId: coinId),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/portfolio/composition',
        pageBuilder: (context, state) =>
            AppTransitions.push(state: state, child: const CompositionPage()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => BlocProvider(
                  create: (context) => sl<HomeCubit>()..fetchTopCoins(),
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/market',
                builder: (context, state) => BlocProvider(
                  create: (context) => sl<MarketCubit>()..fetchMarkets(),
                  child: const MarketPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/watchlist',
                builder: (context, state) => const WatchlistPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/portfolio',
                builder: (context, state) => const PortfolioPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static String _getInitialLocation() {
    final storage = sl<StorageService>();
    final seen =
        storage.readValue<bool>(AppConstants.storageKeyOnboardingSeen) ?? false;
    return seen ? '/home' : '/onboarding';
  }
}
