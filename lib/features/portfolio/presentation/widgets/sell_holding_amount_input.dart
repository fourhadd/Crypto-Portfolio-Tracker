// features/portfolio/presentation/widgets/sell_holding_amount_input.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/sell_holding_cubit.dart';
import '../cubit/sell_holding_state.dart';

class SellHoldingAmountInput extends StatefulWidget {
  final String coinSymbol;
  final double maxAmount;

  const SellHoldingAmountInput({
    super.key,
    required this.coinSymbol,
    required this.maxAmount,
  });

  @override
  State<SellHoldingAmountInput> createState() => _SellHoldingAmountInputState();
}

class _SellHoldingAmountInputState extends State<SellHoldingAmountInput> {
  final TextEditingController _controller = TextEditingController(text: '0');

  static const _percents = [0.25, 0.5, 0.75, 1.0];
  static const _percentLabels = ['25%', '50%', '75%', 'MAX'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncController(double amount) {
    final text = amount == 0 ? '0' : _trim(amount);
    if (_controller.text != text) {
      _controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  String _trim(double value) {
    final str = value.toStringAsFixed(8);
    return str
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: AppGlass.decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AMOUNT TO SELL', style: AppTextStyles.microLabel),
          SizedBox(height: 12.h),
          BlocBuilder<SellHoldingCubit, SellHoldingState>(
            buildWhen: (prev, curr) => prev.sellAmount != curr.sellAmount,
            builder: (context, state) {
              _syncController(state.sellAmount);
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: AppTextStyles.displayLarge,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) =>
                          context.read<SellHoldingCubit>().setAmount(value),
                    ),
                  ),
                  Text(
                    widget.coinSymbol.toUpperCase(),
                    style: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.bgElevatedBorder, height: 1),
          SizedBox(height: 16.h),
          BlocBuilder<SellHoldingCubit, SellHoldingState>(
            buildWhen: (prev, curr) => prev.sellAmount != curr.sellAmount,
            builder: (context, state) {
              return Row(
                children: List.generate(_percents.length, (i) {
                  final isSelected =
                      (state.sellAmount - widget.maxAmount * _percents[i])
                              .abs() <
                          0.00000001 &&
                      widget.maxAmount > 0;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: i == _percents.length - 1 ? 0 : 8.w,
                      ),
                      child: GestureDetector(
                        onTap: () => context
                            .read<SellHoldingCubit>()
                            .setPercent(_percents[i]),
                        child: Container(
                          height: 40.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accentAmberGlow
                                : AppColors.glassBg,
                            borderRadius: BorderRadius.circular(
                              AppRadius.button,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentAmber
                                  : AppColors.glassBorder,
                            ),
                          ),
                          child: Text(
                            _percentLabels[i],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isSelected
                                  ? AppColors.accentAmber
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          SizedBox(height: 16.h),
          BlocBuilder<SellHoldingCubit, SellHoldingState>(
            buildWhen: (prev, curr) => prev.sellAmount != curr.sellAmount,
            builder: (context, state) {
              final remaining = widget.maxAmount - state.sellAmount;
              return Text.rich(
                TextSpan(
                  style: AppTextStyles.bodySmall,
                  children: [
                    const TextSpan(text: 'Remaining: '),
                    TextSpan(
                      text:
                          '${_trim(remaining < 0 ? 0 : remaining)} ${widget.coinSymbol.toUpperCase()}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
