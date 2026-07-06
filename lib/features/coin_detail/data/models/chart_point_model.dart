// features/coin_detail/data/models/chart_point_model.dart
import '../../domain/entities/chart_point_entity.dart';

class ChartPointModel extends ChartPointEntity {
  const ChartPointModel({required super.timestamp, required super.price});

  static List<ChartPointModel> listFromJson(Map<String, dynamic> json) {
    final List<dynamic> prices = json['prices'] as List<dynamic>? ?? [];

    return prices.map((entry) {
      final list = entry as List<dynamic>;
      final timestampMs = (list[0] as num).toInt();
      final price = (list[1] as num).toDouble();

      return ChartPointModel(
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMs),
        price: price,
      );
    }).toList();
  }
}
