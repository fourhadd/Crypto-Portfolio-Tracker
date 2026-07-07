// features/compare/data/models/compare_chart_point_model.dart
import 'package:crypto_portfolio_tracker/features/compare/domain/entities/compare_chart_point.dart';

class CompareChartPointModel extends CompareChartPoint {
  const CompareChartPointModel({required super.time, required super.price});

  factory CompareChartPointModel.fromRaw(List<dynamic> raw) {
    return CompareChartPointModel(
      time: DateTime.fromMillisecondsSinceEpoch((raw[0] as num).toInt()),
      price: (raw[1] as num).toDouble(),
    );
  }
}
