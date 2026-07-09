import 'package:equatable/equatable.dart';
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';

enum AddHoldingStatus { initial, submitting, success, failure }

class AddHoldingState extends Equatable {
  final CoinEntity? coin;
  final double? quantity;
  final double? buyPrice;
  final DateTime buyDate;
  final AddHoldingStatus status;
  final String? errorMessage;

  const AddHoldingState({
    this.coin,
    this.quantity,
    this.buyPrice,
    required this.buyDate,
    this.status = AddHoldingStatus.initial,
    this.errorMessage,
  });

  factory AddHoldingState.initial() => AddHoldingState(buyDate: DateTime.now());

  bool get isValid =>
      coin != null && (quantity ?? 0) > 0 && (buyPrice ?? 0) > 0;

  bool get isSubmitting => status == AddHoldingStatus.submitting;

  AddHoldingState copyWith({
    CoinEntity? coin,
    double? quantity,
    double? buyPrice,
    DateTime? buyDate,
    AddHoldingStatus? status,
    String? errorMessage,
  }) {
    return AddHoldingState(
      coin: coin ?? this.coin,
      quantity: quantity ?? this.quantity,
      buyPrice: buyPrice ?? this.buyPrice,
      buyDate: buyDate ?? this.buyDate,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    coin,
    quantity,
    buyPrice,
    buyDate,
    status,
    errorMessage,
  ];
}
