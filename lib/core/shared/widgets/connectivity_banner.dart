// core/shared/widgets/connectivity_banner.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../cubit/connectivity_cubit.dart';

class ConnectivityBanner extends StatefulWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  static const _autoDismissAfter = Duration(seconds: 5);

  bool _visible = false;
  Timer? _dismissTimer;

  void _show() {
    _dismissTimer?.cancel();
    setState(() => _visible = true);
    _dismissTimer = Timer(_autoDismissAfter, () {
      if (mounted) setState(() => _visible = false);
    });
  }

  void _hide() {
    _dismissTimer?.cancel();
    if (_visible) setState(() => _visible = false);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        BlocListener<ConnectivityCubit, ConnectivityStatus>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, status) {
            if (status == ConnectivityStatus.offline) {
              _show();
            } else {
              _hide();
            }
          },
          child: Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              offset: _visible ? Offset.zero : const Offset(0, -1.2),
              child: SafeArea(
                bottom: false,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurfaceSolid,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.negative, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.glassShadow,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          color: AppColors.negative,
                          size: 18.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'No internet connection',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Check your Wi-Fi/mobile data connection',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            _show();
                            context.read<ConnectivityCubit>().checkNow();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentAmber,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 14.sp,
                                  color: AppColors.onAccent,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Retry',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.onAccent,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
