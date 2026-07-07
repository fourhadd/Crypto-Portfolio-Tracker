// features/compare/presentation/widgets/coin_selector_chip.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class CoinSelectorChip extends StatelessWidget {
  final String? symbol;
  final String? imageUrl;
  final Color accentColor;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const CoinSelectorChip({
    super.key,
    required this.symbol,
    required this.imageUrl,
    required this.accentColor,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasCoin = symbol != null;

    return GestureDetector(
      onTap: hasCoin ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.glassBg,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(
            color: hasCoin
                ? accentColor.withValues(alpha: 0.5)
                : AppColors.glassBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasCoin && imageUrl != null && imageUrl!.isNotEmpty)
              ClipOval(
                child: Image.network(
                  imageUrl!,
                  width: 22.w,
                  height: 22.w,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.currency_bitcoin,
                    size: 22.w,
                    color: accentColor,
                  ),
                ),
              )
            else
              Icon(
                Icons.add_circle_outline,
                size: 20.w,
                color: AppColors.textSecondary,
              ),
            SizedBox(width: 8.w),
            Text(
              hasCoin ? symbol! : 'Seç',
              style: AppTextStyles.tokenSymbol.copyWith(
                color: hasCoin
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (hasCoin && onRemove != null) ...[
              SizedBox(width: 6.w),
              GestureDetector(
                onTap: onRemove,
                child: Icon(Icons.close, size: 16.w, color: accentColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
