// core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color bgBase = Color(0xFF0A0A0B);
  static const Color bgElevated = Color(0x08FFFFFF);
  static const Color bgElevatedBorder = Color(0x14FFFFFF);

  static const Color bgSurfaceSolid = Color(0xFF16171A);

  static const Color glassBg = Color(0x0FFFFFFF);
  static const Color glassBorder = Color(0x1FFFFFFF);
  static const Color glassHighlight = Color(0x26FFFFFF);
  static const Color glassShadow = Color(0x66000000);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFF6B7280);

  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentAmberGlow = Color(0x40FBBF24);

  static const Color onAccent = Color(0xFF1A1408);

  static const Color positive = Color(0xFF4ADE80);
  static const Color positiveBg = Color(0x1A4ADE80);
  static const Color negative = Color(0xFFF87171);
  static const Color negativeBg = Color(0x1AF87171);

  static const Color chartPrimary = accentAmber;
  static const Color chartSecondary = Color(0xFF2DD4BF);

  static Color changeColor(double percentChange) =>
      percentChange >= 0 ? positive : negative;

  static Color changeBgColor(double percentChange) =>
      percentChange >= 0 ? positiveBg : negativeBg;
}
