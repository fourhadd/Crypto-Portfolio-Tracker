// core/shared/widgets/app_bottom_nav_bar.dart
// core/shared/widgets/app_bottom_nav_bar.dart — tam fayl
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

enum AppNavTab { home, market, watchlist, portfolio }

class AppBottomNavBar extends StatelessWidget {
  final AppNavTab currentTab;
  final ValueChanged<AppNavTab> onTabSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final radius = 32.r;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.glassBg,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: AppNavTab.values
                .map(
                  (tab) => _NavItem(
                    tab: tab,
                    isSelected: tab == currentTab,
                    onTap: () => onTabSelected(tab),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final AppNavTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.accentAmber : AppColors.textTertiary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        height: 56.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isSelected ? 1 : 0,
              child: _Glow(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_iconFor(tab), size: 19.sp, color: color),
                SizedBox(height: 3.h),
                Text(
                  _labelFor(tab),
                  style: AppTextStyles.navLabel.copyWith(color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(AppNavTab tab) {
    switch (tab) {
      case AppNavTab.home:
        return Icons.home_rounded;
      case AppNavTab.market:
        return Icons.bar_chart_rounded;
      case AppNavTab.watchlist:
        return Icons.star_rounded;
      case AppNavTab.portfolio:
        return Icons.account_balance_wallet_rounded;
    }
  }

  String _labelFor(AppNavTab tab) {
    switch (tab) {
      case AppNavTab.home:
        return 'Home';
      case AppNavTab.market:
        return 'Market';
      case AppNavTab.watchlist:
        return 'Watchlist';
      case AppNavTab.portfolio:
        return 'Portfolio';
    }
  }
}

class _Glow extends StatelessWidget {
  const _Glow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.accentAmber.withValues(alpha: 0.45),
            AppColors.accentAmber.withValues(alpha: 0.15),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentAmber.withValues(alpha: 0.4),
            blurRadius: 20.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
    );
  }
}
