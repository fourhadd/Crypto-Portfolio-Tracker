// features/coin_detail/domain/entities/chart_point_entity.dart
import 'package:equatable/equatable.dart';

enum ChartRange {
  oneHour,
  twentyFourHour,
  sevenDay,
  oneMonth,
  threeMonth,
  oneYear,
}

extension ChartRangeX on ChartRange {
  String get label {
    switch (this) {
      case ChartRange.oneHour:
        return '1H';
      case ChartRange.twentyFourHour:
        return '24H';
      case ChartRange.sevenDay:
        return '7D';
      case ChartRange.oneMonth:
        return '1M';
      case ChartRange.threeMonth:
        return '3M';
      case ChartRange.oneYear:
        return '1Y';
    }
  }

  String get daysParam {
    switch (this) {
      case ChartRange.oneHour:
        return '0.04';
      case ChartRange.twentyFourHour:
        return '1';
      case ChartRange.sevenDay:
        return '7';
      case ChartRange.oneMonth:
        return '30';
      case ChartRange.threeMonth:
        return '90';
      case ChartRange.oneYear:
        return '365';
    }
  }
}

class ChartPointEntity extends Equatable {
  final DateTime timestamp;
  final double price;

  const ChartPointEntity({required this.timestamp, required this.price});

  @override
  List<Object?> get props => [timestamp, price];
}
