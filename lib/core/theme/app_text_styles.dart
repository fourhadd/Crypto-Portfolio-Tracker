// core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => TextStyle(
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w900,
    fontSize: 32.sp,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get headingLarge => TextStyle(
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
    fontSize: 24.sp,
    color: AppColors.textPrimary,
  );

  static TextStyle get headingMedium => TextStyle(
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: AppColors.textPrimary,
  );

  static TextStyle get balanceLarge => TextStyle(
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w900,
    fontSize: 36.sp,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get balanceMedium => TextStyle(
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
    color: AppColors.textPrimary,
  );

  static TextStyle get buttonText => TextStyle(
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get microLabel => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
    letterSpacing: 0.4,
  );

  static TextStyle get navLabel => TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get percentChange => TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get percentChangeLarge => TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get tokenSymbol => TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static TextStyle get tagline => TextStyle(
    fontFamily: 'SpaceGrotesk',
    fontSize: 26.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );
}
