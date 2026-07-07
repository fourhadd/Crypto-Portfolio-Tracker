// features/portfolio/data/models/holding_model.dart
import '../../domain/entities/holding_entity.dart';

class HoldingModel extends HoldingEntity {
  const HoldingModel({
    required super.id,
    required super.coinId,
    required super.amount,
    required super.buyPrice,
    required super.buyDate,
  });

  factory HoldingModel.fromEntity(HoldingEntity entity) => HoldingModel(
    id: entity.id,
    coinId: entity.coinId,
    amount: entity.amount,
    buyPrice: entity.buyPrice,
    buyDate: entity.buyDate,
  );

  factory HoldingModel.fromJson(Map<String, dynamic> json) {
    return HoldingModel(
      id: json['id'] as String,
      coinId: json['coinId'] as String,
      amount: (json['amount'] as num).toDouble(),
      buyPrice: (json['buyPrice'] as num).toDouble(),
      buyDate: DateTime.parse(json['buyDate'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'coinId': coinId,
    'amount': amount,
    'buyPrice': buyPrice,
    'buyDate': buyDate.toIso8601String(),
  };
}
