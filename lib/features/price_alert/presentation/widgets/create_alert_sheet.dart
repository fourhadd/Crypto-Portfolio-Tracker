// features/alerts/presentation/widgets/create_alert_sheet.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';
import 'package:crypto_portfolio_tracker/features/compare/presentation/widgets/coin_picker_bottom_sheet.dart';
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
  final _priceController = TextEditingController();
  AlertCondition _condition = AlertCondition.above;
  CoinEntity? _selectedCoin;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickCoin() async {
    final coin = await CoinPickerBottomSheet.show(context);
    if (coin == null || !mounted) return;

    setState(() {
      _selectedCoin = coin;
      // Hədəf qiyməti avtomatik hazırkı qiymətlə doldur - istifadəçi
      // istəsə üstünə yaza bilər, sadəcə başlanğıc nöqtəsi olsun.
      _priceController.text = coin.currentPrice.toString();
    });
  }

  void _submit() {
    final coin = _selectedCoin;
    final price = double.tryParse(_priceController.text.trim());

    if (coin == null || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Zəhmət olmasa coin seçin və düzgün qiymət daxil edin'),
        ),
      );
      return;
    }

    context.read<PriceAlertsCubit>().addAlert(
      coinId: coin.id,
      symbol: coin.symbol,
      targetPrice: price,
      condition: _condition,
    );
    Navigator.of(context).pop();
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
            SizedBox(height: 24.h),
            _CoinSelectButton(coin: _selectedCoin, onTap: _pickCoin),
            SizedBox(height: 20.h),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(color: AppColors.textPrimary),
              decoration: _inputDecoration('Target price'),
            ),
            SizedBox(height: 20.h),
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
            SizedBox(height: 28.h),
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

/// Portfolio-dakı `CoinSelectField` ilə eyni vizual dil - seçilmiş coin-i
/// ikon + ad/simvol ilə göstərir, tap olunanda `CoinPickerBottomSheet` açır.
class _CoinSelectButton extends StatelessWidget {
  final CoinEntity? coin;
  final VoidCallback onTap;

  const _CoinSelectButton({required this.coin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.chip),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(color: AppColors.glassBorder, width: 1),
        ),
        child: Row(
          children: [
            if (coin != null) ...[
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: coin!.image,
                  width: 22.w,
                  height: 22.w,
                  placeholder: (_, __) => SizedBox(width: 22.w, height: 22.w),
                  errorWidget: (_, __, ___) => Icon(
                    Icons.currency_bitcoin,
                    size: 22.w,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],
            Expanded(
              child: Text(
                coin != null
                    ? '${coin!.name} (${coin!.symbol.toUpperCase()})'
                    : 'Select a coin...',
                style: coin != null
                    ? AppTextStyles.bodyMedium
                    : AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}
