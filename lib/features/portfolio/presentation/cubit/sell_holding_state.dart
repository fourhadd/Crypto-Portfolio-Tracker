// features/portfolio/presentation/cubit/sell_holding_state.dart
import 'package:equatable/equatable.dart';

enum SellHoldingStatus { initial, submitting, success, failure }

class SellHoldingState extends Equatable {
  final double sellAmount;
  final SellHoldingStatus status;
  final String? errorMessage;

  const SellHoldingState({
    this.sellAmount = 0,
    this.status = SellHoldingStatus.initial,
    this.errorMessage,
  });

  bool get isSubmitting => status == SellHoldingStatus.submitting;

  SellHoldingState copyWith({
    double? sellAmount,
    SellHoldingStatus? status,
    String? errorMessage,
  }) {
    return SellHoldingState(
      sellAmount: sellAmount ?? this.sellAmount,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [sellAmount, status, errorMessage];
}
