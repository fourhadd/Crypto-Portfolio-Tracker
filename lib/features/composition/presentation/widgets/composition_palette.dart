// features/composition/presentation/widgets/composition_palette.dart
import 'package:flutter/material.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

const List<Color> _compositionPalette = [
  AppColors.accentAmber,
  AppColors.chartSecondary,
  Color(0xFFF87171),
  Color(0xFF60A5FA),
  Color(0xFFC084FC),
  Color(0xFFFB923C),
  Color(0xFF34D399),
  Color(0xFFF472B6),
];

Color compositionPaletteColor(int index) {
  return _compositionPalette[index % _compositionPalette.length];
}
