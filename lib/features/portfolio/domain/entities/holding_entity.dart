// features/portfolio/domain/entities/holding_entity.dart
import 'package:equatable/equatable.dart';

class HoldingEntity extends Equatable {
  final String id;
  final String coinId;
  final double amount;
  final double buyPrice;
  final DateTime buyDate;

  const HoldingEntity({
    required this.id,
    required this.coinId,
    required this.amount,
    required this.buyPrice,
    required this.buyDate,
  });

  @override
  List<Object?> get props => [id, coinId, amount, buyPrice, buyDate];
}

