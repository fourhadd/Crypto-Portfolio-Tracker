// core/utils/number_formatter.dart
import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  // Fix #31: cache intl NumberFormat instances instead of constructing
  // them fresh inside build() on every rebuild.
  static final NumberFormat usdFormat = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat fourDecimalFormat = NumberFormat('#,##0.0000');
  static final NumberFormat usdCurrencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );
  static final NumberFormat compactUsdFormat = NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '',
  );

  static String formatCurrency(double value, {int decimals = 2}) {
    final isNegative = value < 0;
    final absValue = value.abs();
    final parts = absValue.toStringAsFixed(decimals).split('.');
    final wholePart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    final buffer = StringBuffer();
    for (int i = 0; i < wholePart.length; i++) {
      if (i > 0 && (wholePart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(wholePart[i]);
    }

    final sign = isNegative ? '-' : '';
    final decimalSuffix = decimals > 0 ? '.$decimalPart' : '';
    return '$sign\$$buffer$decimalSuffix';
  }

  static String formatCompactVolume(double value) {
    if (value >= 1e9) return '\$${(value / 1e9).toStringAsFixed(2)}B';
    if (value >= 1e6) return '\$${(value / 1e6).toStringAsFixed(2)}M';
    if (value >= 1e3) return '\$${(value / 1e3).toStringAsFixed(2)}K';
    return '\$${value.toStringAsFixed(2)}';
  }

  static String formatPercent(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  // Fix #23: raw double.toString() on coin amounts shows floating-point
  // artifacts like 0.10000000000000001. Format to a fixed precision and
  // trim trailing zeros / a dangling decimal point.
  static String formatCoinAmount(double value) {
    final fixed = value.toStringAsFixed(8);
    final trimmed = fixed
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
    return trimmed.isEmpty ? '0' : trimmed;
  }
}
