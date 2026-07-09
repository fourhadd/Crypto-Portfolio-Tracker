// features/market/presentation/widgets/market_coin_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/core_coin_list_tile.dart';
import '../../../home/presentation/widgets/coin_list_skeleton.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/market_cubit.dart';
import '../cubit/market_state.dart';

class MarketCoinListView extends StatelessWidget {
  const MarketCoinListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketCubit, MarketState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == MarketStatus.loading) {
          return const CoreCoinListSkeleton(itemCount: 8);
        }

        if (state.status == MarketStatus.error) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Xəta baş verdi',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.negative,
              ),
            ),
          );
        }

        if (state.status == MarketStatus.loaded) {
          if (state.coins.isEmpty) {
            return Center(
              child: Text('Nəticə tapılmadı', style: AppTextStyles.bodyMedium),
            );
          }

          return RefreshIndicator(
            color: AppColors.accentAmber,
            onRefresh: () => context.read<MarketCubit>().refreshMarkets(),
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 90.h),
              itemCount: state.coins.length,
              separatorBuilder: (_, __) =>
                  Divider(color: AppColors.bgElevatedBorder, height: 1),
              itemBuilder: (_, index) => CoreCoinListTile(
                rank: index + 1,
                coin: state.coins[index],
                showSparkline: true,
                onTap: () => context.push('/coin/${state.coins[index].id}'),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
