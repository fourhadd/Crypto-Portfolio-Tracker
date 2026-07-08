// core/shared/widgets/main_wrapper.dart
import 'dart:async';

import 'package:crypto_portfolio_tracker/core/shared/widgets/app_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  static const _homeBranchIndex = 0;
  static const _exitPromptWindow = Duration(seconds: 2);
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    // Tab keçidi üçün yüngül fade + çox incə scale — smooth hiss versin deyə
    // əvvəlkindən bir az daha uzun müddət və yumşaq curve istifadə olunur.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _scale = Tween<double>(
      begin: 0.985,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.value = 1;
  }

  @override
  void didUpdateWidget(covariant MainWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // navigationShell öz daxili GlobalKey-ni saxlayır — ona görə onu heç vaxt
    // yenidən key-ləmirik / iki nüsxədə saxlamırıq (AnimatedSwitcher kimi),
    // yalnız tək instans üzərində opacity animasiyasını "replay" edirik.
    if (oldWidget.navigationShell.currentIndex !=
        widget.navigationShell.currentIndex) {
      _controller
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  /// Geri (back) əməliyyatını idarə edir:
  /// - Home-dan başqa tab-dadırsa → Home-a qayıdır (app bağlanmır).
  /// - Home-dadırsa → 2 saniyə ərzində ikinci dəfə basılmasa xəbərdarlıq
  ///   göstərir, ikinci dəfə basılsa app bağlanır (həm Android, həm iOS-da
  ///   işləyir — cross-platform, iOS-da isə praktikada yalnız proqramatik
  ///   geri çağırışlar üçün, məs. sistem gesture-ı əvəzinə).
  Future<void> _handleBackNavigation() async {
    final currentIndex = widget.navigationShell.currentIndex;

    if (currentIndex != _homeBranchIndex) {
      widget.navigationShell.goBranch(_homeBranchIndex);
      return;
    }

    final now = DateTime.now();
    final isSecondPress =
        _lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) <= _exitPromptWindow;

    if (isSecondPress) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPressTime = now;
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Çıxmaq üçün yenidən basın'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = AppNavTab.values[widget.navigationShell.currentIndex];

    return PopScope(
      // Heç vaxt sistemin default pop davranışına icazə vermirik — məntiqi
      // tam özümüz idarə edirik (_handleBackNavigation).
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: widget.navigationShell,
                ),
              ),
            ),
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
      ),
    );
  }
}
