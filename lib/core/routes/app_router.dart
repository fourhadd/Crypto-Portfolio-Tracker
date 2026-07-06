// core/routes/app_router.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/market/presentation/cubit/market_cubit.dart';
import '../../features/market/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../constants/app_constants.dart';
import '../di/injection_container.dart';
import '../local_storage/storage_service.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: _getInitialLocation(),
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => BlocProvider(
          create: (context) => sl<OnboardingCubit>(),
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => BlocProvider(
          create: (context) => sl<MarketCubit>()..fetchTopCoins(),
          child: const HomePage(),
        ),
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
