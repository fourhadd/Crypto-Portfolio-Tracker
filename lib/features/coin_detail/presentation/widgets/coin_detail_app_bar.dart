// features/coin_detail/presentation/widgets/coin_detail_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/coin_detail_cubit.dart';
import '../cubit/coin_detail_state.dart';

class CoinDetailAppBar extends StatelessWidget {
  const CoinDetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
        Expanded(child: const _CoinTitle()),
        const _WatchlistButton(),
      ],
    );
  }
}

class _CoinTitle extends StatelessWidget {
  const _CoinTitle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDetailCubit, CoinDetailState>(
      buildWhen: (previous, current) => current is CoinDetailLoaded,
      builder: (context, state) {
        if (state is! CoinDetailLoaded) return const SizedBox.shrink();
        final coin = state.coin;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                coin.image,
                width: 24.w,
                height: 24.h,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.currency_bitcoin,
                  size: 20.sp,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(coin.name, style: AppTextStyles.headingMedium),
            SizedBox(width: 6.w),
            Text(
              coin.symbol.toUpperCase(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WatchlistButton extends StatelessWidget {
  const _WatchlistButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDetailCubit, CoinDetailState>(
      buildWhen: (previous, current) => current is CoinDetailLoaded,
      builder: (context, state) {
        final isInWatchlist = state is CoinDetailLoaded && state.isInWatchlist;

        return _CircleIconButton(
          icon: isInWatchlist ? Icons.star_rounded : Icons.star_border_rounded,
          iconColor: isInWatchlist ? AppColors.accentAmber : null,
          onTap: () => context.read<CoinDetailCubit>().toggleWatchlist(),
        );
      },
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.bgElevated,
          border: Border.all(color: AppColors.bgElevatedBorder),
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: iconColor ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}
