// features/alerts/domain/price_alert.dart

enum AlertCondition { above, below }

class PriceAlert {
  final String id;
  final String symbol;

  /// CoinGecko coin id (e.g. 'bitcoin'), used to match this alert to a
  /// specific coin instead of its ticker symbol. Nullable to stay
  /// backward-compatible with alerts persisted before this field
  /// existed - those fall back to symbol matching (see PriceAlertsCubit).
  final String? coinId;
  final double targetPrice;
  final AlertCondition condition;
  final bool isActive;

  /// Last price seen for this alert while it was active. Used to detect
  /// an actual *crossing* of [targetPrice] rather than firing just
  /// because the current price already happens to satisfy the
  /// condition (e.g. right after toggling an old alert back on).
  /// Null means "just armed" - the next check only records a baseline,
  /// it never fires on that first check.
  final double? lastKnownPrice;

  const PriceAlert({
    required this.id,
    required this.symbol,
    this.coinId,
    required this.targetPrice,
    required this.condition,
    this.isActive = true,
    this.lastKnownPrice,
  });

  PriceAlert copyWith({
    bool? isActive,
    double? lastKnownPrice,
    bool clearLastKnownPrice = false,
  }) => PriceAlert(
    id: id,
    symbol: symbol,
    coinId: coinId,
    targetPrice: targetPrice,
    condition: condition,
    isActive: isActive ?? this.isActive,
    lastKnownPrice: clearLastKnownPrice
        ? null
        : (lastKnownPrice ?? this.lastKnownPrice),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'coinId': coinId,
    'targetPrice': targetPrice,
    'condition': condition.name,
    'isActive': isActive,
    'lastKnownPrice': lastKnownPrice,
  };

  factory PriceAlert.fromJson(Map<String, dynamic> json) => PriceAlert(
    id: json['id'] as String,
    symbol: json['symbol'] as String,
    coinId: json['coinId'] as String?,
    targetPrice: (json['targetPrice'] as num).toDouble(),
    condition: AlertCondition.values.firstWhere(
      (c) => c.name == json['condition'],
      orElse: () => AlertCondition.above,
    ),
    isActive: json['isActive'] as bool? ?? true,
    lastKnownPrice: (json['lastKnownPrice'] as num?)?.toDouble(),
  );
}
