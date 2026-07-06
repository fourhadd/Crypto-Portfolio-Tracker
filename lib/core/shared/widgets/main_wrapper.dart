// core/shared/widgets/main_wrapper.dart
import 'package:crypto_portfolio_tracker/core/shared/widgets/app_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = AppNavTab.values[navigationShell.currentIndex];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Positioned(
            left: 24.w,
            right: 24.w,
            bottom: 24.h,
            child: AppBottomNavBar(
              currentTab: currentTab,
              onTabSelected: (tab) => _onTabSelected(tab.index),
            ),
          ),
        ],
      ),
    );
  }
}
