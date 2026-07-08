// app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/di/injection_container.dart';
import '../core/routes/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/portfolio/presentation/cubit/portfolio_cubit.dart';

class CryptoTrackerApp extends StatelessWidget {
  const CryptoTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider<PortfolioCubit>(
          create: (_) => sl<PortfolioCubit>()..startWatching(),
          lazy: false,
          child: MaterialApp.router(
            title: 'Crypto Portfolio Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
