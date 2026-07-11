// features/watchlist/presentation/pages/watchlist_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/watchlist_cubit.dart';
import '../cubit/watchlist_state.dart';
import '../widgets/watchlist_empty_state.dart';
import '../widgets/watchlist_header.dart';
import '../widgets/watchlist_list.dart';
import '../../../../core/shared/widgets/core_network_error_view.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WatchlistCubit>()..startWatching(),
      child: Scaffold(
        backgroundColor: AppColors.bgBase,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                const WatchlistHeader(),
                SizedBox(height: 24.h),
                Expanded(
                  child: BlocBuilder<WatchlistCubit, WatchlistState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case WatchlistStatus.initial:
                        case WatchlistStatus.loading:
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.accentAmber,
                            ),
                          );
                        case WatchlistStatus.error:
                          return CoreNetworkErrorView(
                            message: state.errorMessage,
                            onRetry: () =>
                                context.read<WatchlistCubit>().startWatching(),
                          );
                        case WatchlistStatus.loaded:
                          if (state.coins.isEmpty) {
                            return const WatchlistEmptyState();
                          }
                          return WatchlistList(coins: state.coins);
                      }
                    },
                  ),
                ),

                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
