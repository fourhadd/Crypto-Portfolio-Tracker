// features/watchlist/presentation/pages/watchlist_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/watchlist_cubit.dart';
import '../cubit/watchlist_state.dart';
import '../widgets/watchlist_header.dart';
import '../widgets/watchlist_empty_state.dart';
import '../widgets/watchlist_list.dart';

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
                      if (state is WatchlistLoading ||
                          state is WatchlistInitial) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentAmber,
                          ),
                        );
                      }
                      if (state is WatchlistError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: AppTextStyles.bodyMedium,
                          ),
                        );
                      }
                      if (state is WatchlistLoaded) {
                        if (state.isEmpty) {
                          return const WatchlistEmptyState();
                        }
                        return WatchlistList(coins: state.coins);
                      }
                      return const SizedBox.shrink();
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
