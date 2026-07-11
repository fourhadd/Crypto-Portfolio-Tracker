// features/home/presentation/widgets/coin_list_view.dart
import 'package:crypto_portfolio_tracker/features/home/presentation/widgets/coin_list_skeleton.dart';
import 'package:crypto_portfolio_tracker/core/shared/widgets/core_coin_list_tile.dart';
import 'package:crypto_portfolio_tracker/core/shared/widgets/core_network_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/domain/entities/coin_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class CoinListView extends StatelessWidget {
  final ValueChanged<CoinEntity> onCoinTap;

  const CoinListView({super.key, required this.onCoinTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.coins != current.coins,
      builder: (context, state) {
        if (state.status == HomeStatus.error) {
          return CoreNetworkErrorView(
            message: state.errorMessage,
            onRetry: () => context.read<HomeCubit>().fetchTopCoins(),
          );
        }

        if (state.status == HomeStatus.loaded) {
          if (state.coins.isEmpty) {
            return const _MessageBox(text: 'Coin tapılmadı');
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.coins.length,
            separatorBuilder: (_, __) =>
                Divider(color: AppColors.glassBorder, height: 1.h),
            itemBuilder: (context, index) => CoreCoinListTile(
              rank: index + 1,
              coin: state.coins[index],
              showVolume: true,
              onTap: () => onCoinTap(state.coins[index]),
            ),
          );
        }

        return const CoreCoinListSkeleton(itemCount: 5);
      },
    );
  }
}

class _MessageBox extends StatelessWidget {
  final String text;

  const _MessageBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Text(
          text,
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
