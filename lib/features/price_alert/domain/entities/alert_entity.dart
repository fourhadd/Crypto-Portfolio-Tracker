// features/alerts/domain/price_alert.dart

enum AlertCondition { above, below }

class PriceAlert {
  final String id;
  final String symbol;
  final double targetPrice;
  final AlertCondition condition;
  final bool isActive;

  const PriceAlert({
    required this.id,
    required this.symbol,
    required this.targetPrice,
    required this.condition,
    this.isActive = true,
  });

  PriceAlert copyWith({bool? isActive}) => PriceAlert(
    id: id,
    symbol: symbol,
    targetPrice: targetPrice,
    condition: condition,
    isActive: isActive ?? this.isActive,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'targetPrice': targetPrice,
    'condition': condition.name,
    'isActive': isActive,
  };

  factory PriceAlert.fromJson(Map<String, dynamic> json) => PriceAlert(
    id: json['id'] as String,
    symbol: json['symbol'] as String,
    targetPrice: (json['targetPrice'] as num).toDouble(),
    condition: AlertCondition.values.firstWhere(
      (c) => c.name == json['condition'],
      orElse: () => AlertCondition.above,
    ),
    isActive: json['isActive'] as bool? ?? true,
  );
}
