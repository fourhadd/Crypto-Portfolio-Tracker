// features/market/presentation/widgets/coin_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/market_cubit.dart';
import '../cubit/market_state.dart';
import 'coin_list_tile.dart';
import 'coin_list_skeleton.dart';

class CoinListView extends StatelessWidget {
  final ValueChanged<String> onCoinTap;

  const CoinListView({super.key, required this.onCoinTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketCubit, MarketState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        if (state is MarketError) {
          return _MessageBox(text: state.message);
        }

        if (state is MarketLoaded) {
          if (state.coins.isEmpty) {
            return const _MessageBox(text: 'Coin tapılmadı');
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.coins.length,
            separatorBuilder: (_, __) =>
                Divider(color: AppColors.glassBorder, height: 1.h),
            itemBuilder: (context, index) => CoinListTile(
              rank: index + 1,
              coin: state.coins[index],
              onTap: () => onCoinTap(state.coins[index].id),
            ),
          );
        }

        return const CoinListSkeleton(itemCount: 5);
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
