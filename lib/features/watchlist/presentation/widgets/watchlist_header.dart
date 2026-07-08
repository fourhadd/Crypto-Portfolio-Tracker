// features/watchlist/presentation/widgets/watchlist_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/watchlist_cubit.dart';
import '../cubit/watchlist_state.dart';

class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Watchlist', style: AppTextStyles.displayLarge),
            SizedBox(height: 4.h),
            BlocBuilder<WatchlistCubit, WatchlistState>(
              buildWhen: (previous, current) => current is WatchlistLoaded,
              builder: (context, state) {
                final count = state is WatchlistLoaded ? state.coins.length : 0;
                return Text(
                  '$count coin${count == 1 ? '' : 's'} tracked',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ],
        ),
        InkWell(
          borderRadius: BorderRadius.circular(999.r),
          onTap: () => context.go('/market'),
          child: Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: AppColors.accentAmberGlow,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentAmber, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentAmber.withValues(alpha: 0.55),
                  blurRadius: 90.r,
                  spreadRadius: 10.r,
                ),
              ],
            ),
            child: Icon(Icons.add, color: AppColors.accentAmber, size: 22.sp),
          ),
        ),
      ],
    );
  }
}
