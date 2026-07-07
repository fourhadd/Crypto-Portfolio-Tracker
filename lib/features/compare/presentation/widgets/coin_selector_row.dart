// features/compare/presentation/widgets/coin_selector_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';
import '../cubit/compare_cubit.dart';
import '../cubit/compare_state.dart';
import 'coin_selector_chip.dart';
import 'coin_picker_bottom_sheet.dart';

class CoinSelectorRow extends StatelessWidget {
  const CoinSelectorRow({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CompareCubit>();

    return BlocBuilder<CompareCubit, CompareState>(
      buildWhen: (prev, curr) =>
          prev.selectedFirst != curr.selectedFirst ||
          prev.selectedSecond != curr.selectedSecond,
      builder: (context, state) {
        final first = state.selectedFirst;
        final second = state.selectedSecond;

        return Row(
          children: [
            CoinSelectorChip(
              symbol: first != null && first.symbol.isNotEmpty
                  ? first.symbol
                  : null,
              imageUrl: first?.image,
              accentColor: AppColors.chartPrimary,
              onTap: () => _openCoinPicker(context, cubit, isFirst: true),
              onRemove: first != null ? cubit.removeFirstCoin : null,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text('vs', style: AppTextStyles.bodySmall),
            ),
            CoinSelectorChip(
              symbol: second != null && second.symbol.isNotEmpty
                  ? second.symbol
                  : null,
              imageUrl: second?.image,
              accentColor: AppColors.chartSecondary,
              onTap: () => _openCoinPicker(context, cubit, isFirst: false),
              onRemove: second != null ? cubit.removeSecondCoin : null,
            ),
          ],
        );
      },
    );
  }

  Future<void> _openCoinPicker(
    BuildContext context,
    CompareCubit cubit, {
    required bool isFirst,
  }) async {
    final CoinEntity? coin = await CoinPickerBottomSheet.show(context);
    if (coin == null) return;

    if (isFirst) {
      cubit.selectFirstCoin(coin);
    } else {
      cubit.selectSecondCoin(coin);
    }
  }
}
