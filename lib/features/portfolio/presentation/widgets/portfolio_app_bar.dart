// features/portfolio/presentation/widgets/portfolio_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class PortfolioAppBar extends StatelessWidget {
  const PortfolioAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Portfolio',
          style: AppTextStyles.headingLarge.copyWith(fontSize: 26.sp),
        ),
        Row(
          children: [
            _CircleIconButton(
              icon: Icons.pie_chart_outline_rounded,
              background: AppColors.bgElevated,
              iconColor: AppColors.textPrimary,
              onTap: () {
                // TODO: allocation breakdown ekranı/bottom sheet (bu tapşırıqda yoxdur)
              },
            ),
            SizedBox(width: 10.w),
            _CircleIconButton(
              icon: Icons.add_rounded,
              background: AppColors.accentAmber,
              iconColor: AppColors.onAccent,
              onTap: () => context.push('/portfolio/add'),
            ),
          ],
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: Container(
        width: 44.w,
        height: 44.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.bgElevatedBorder, width: 1),
        ),
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
    );
  }
}
