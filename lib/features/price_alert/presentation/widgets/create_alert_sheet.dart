// features/alerts/presentation/widgets/create_alert_sheet.dart
import 'package:crypto_portfolio_tracker/features/price_alert/domain/entities/alert_entity.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_cubit.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/widgets/alert_condition_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class CreateAlertSheet extends StatefulWidget {
  const CreateAlertSheet({super.key});

  @override
  State<CreateAlertSheet> createState() => _CreateAlertSheetState();
}

class _CreateAlertSheetState extends State<CreateAlertSheet> {
  final _symbolController = TextEditingController();
  final _priceController = TextEditingController();
  AlertCondition _condition = AlertCondition.above;

  @override
  void dispose() {
    _symbolController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    final symbol = _symbolController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    if (symbol.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Zəhmət olmasa düzgün coin və qiymət daxil edin'),
        ),
      );
      return;
    }
    context.read<PriceAlertsCubit>().addAlert(
      symbol: symbol,
      targetPrice: price,
      condition: _condition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceSolid,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
        border: Border(
          top: BorderSide(color: AppColors.bgElevatedBorder, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.bgElevatedBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Text('Create Alert', style: AppTextStyles.headingMedium),
            SizedBox(height: 16.h),
            TextField(
              controller: _symbolController,
              textCapitalization: TextCapitalization.characters,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: _inputDecoration('Coin symbol (e.g. BTC)'),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(color: AppColors.textPrimary),
              decoration: _inputDecoration('Target price'),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: AlertConditionChip(
                    label: 'Above',
                    selected: _condition == AlertCondition.above,
                    onTap: () =>
                        setState(() => _condition = AlertCondition.above),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AlertConditionChip(
                    label: 'Below',
                    selected: _condition == AlertCondition.below,
                    onTap: () =>
                        setState(() => _condition = AlertCondition.below),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Create Alert'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.textSecondary),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: AppColors.bgElevatedBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: AppColors.accentAmber),
      ),
    );
  }
}
