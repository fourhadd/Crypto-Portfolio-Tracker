// features/market/presentation/widgets/market_filter_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/market_cubit.dart';

class MarketFilterBottomSheet extends StatefulWidget {
  const MarketFilterBottomSheet({super.key});

  static void show(BuildContext context) {
    final cubit = context.read<MarketCubit>();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const MarketFilterBottomSheet(),
      ),
    );
  }

  @override
  State<MarketFilterBottomSheet> createState() =>
      _MarketFilterBottomSheetState();
}

class _MarketFilterBottomSheetState extends State<MarketFilterBottomSheet> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MarketCubit>();
    _minController = TextEditingController(
      text: cubit.minPrice?.toString() ?? '',
    );
    _maxController = TextEditingController(
      text: cubit.maxPrice?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _apply() {
    final min = double.tryParse(_minController.text.trim());
    final max = double.tryParse(_maxController.text.trim());

    context.read<MarketCubit>().applyAdvancedFilters(
      minPrice: min,
      maxPrice: max,
    );
    Navigator.of(context).pop();
  }

  void _reset() {
    _minController.clear();
    _maxController.clear();
    context.read<MarketCubit>().resetFilters();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
        decoration: BoxDecoration(
          color: AppColors.bgBase,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(color: AppColors.bgElevatedBorder),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 24,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.bgElevatedBorder,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter', style: AppTextStyles.headingMedium),
                GestureDetector(
                  onTap: _reset,
                  child: Text(
                    'Reset',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text('Price range (\$)', style: AppTextStyles.bodySmall),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: _PriceInput(controller: _minController, hint: 'Min'),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _PriceInput(controller: _maxController, hint: 'Max'),
                ),
              ],
            ),
            SizedBox(height: 28.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _apply,
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _PriceInput({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.bgElevatedBorder),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
          border: InputBorder.none,
          isCollapsed: true,
        ),
      ),
    );
  }
}
