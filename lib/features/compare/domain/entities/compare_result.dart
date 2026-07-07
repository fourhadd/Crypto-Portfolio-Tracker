// features/compare/domain/entities/compare_result.dart
import 'coin_compare_data.dart';

class CompareResult {
  final CoinCompareData first;
  final CoinCompareData second;

  const CompareResult({required this.first, required this.second});
}
