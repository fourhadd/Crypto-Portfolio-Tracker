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
    bool clearError = false,
  }) {
    return SellHoldingState(
      sellAmount: sellAmount ?? this.sellAmount,
      status: status ?? this.status,

      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [sellAmount, status, errorMessage];
}
