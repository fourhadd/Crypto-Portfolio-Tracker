// shared/widgets/app_bottom_nav_bar.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

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
    final selectedIndex = AppNavTab.values.indexOf(currentTab);
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              _SelectedGlow(
                tabCount: AppNavTab.values.length,
                selectedIndex: selectedIndex,
              ),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedGlow extends StatelessWidget {
  final int tabCount;
  final int selectedIndex;

  const _SelectedGlow({required this.tabCount, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final dx = -1.0 + (selectedIndex * 2 / (tabCount - 1));

    return AnimatedAlign(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      alignment: Alignment(dx, 0),
      child: Container(
        width: 52.w,
        height: 52.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [AppColors.accentAmberGlow, Colors.transparent],
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
      child: Column(
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
