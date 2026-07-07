// features/compare/presentation/cubit/compare_state.dart
import 'package:equatable/equatable.dart';
import 'package:crypto_portfolio_tracker/features/compare/domain/entities/compare_result.dart';
import 'package:crypto_portfolio_tracker/features/compare/domain/entities/compare_coin_ref.dart';

enum CompareTimeframe { day1, day7, month1, month3 }

extension CompareTimeframeX on CompareTimeframe {
  String get apiValue {
    switch (this) {
      case CompareTimeframe.day1:
        return '1';
      case CompareTimeframe.day7:
        return '7';
      case CompareTimeframe.month1:
        return '30';
      case CompareTimeframe.month3:
        return '90';
    }
  }

  String get label {
    switch (this) {
      case CompareTimeframe.day1:
        return '24H';
      case CompareTimeframe.day7:
        return '7D';
      case CompareTimeframe.month1:
        return '1M';
      case CompareTimeframe.month3:
        return '3M';
    }
  }
}

enum CompareStatus { idle, loading, loaded, error }

class CompareState extends Equatable {
  final CompareStatus status;
  final CompareCoinRef? selectedFirst;
  final CompareCoinRef? selectedSecond;
  final CompareTimeframe timeframe;
  final CompareResult? result;
  final String? errorMessage;

  const CompareState({
    this.status = CompareStatus.idle,
    this.selectedFirst,
    this.selectedSecond,
    this.timeframe = CompareTimeframe.day7,
    this.result,
    this.errorMessage,
  });

  bool get hasBothCoins => selectedFirst != null && selectedSecond != null;

  CompareState copyWith({
    CompareStatus? status,
    CompareCoinRef? selectedFirst,
    bool clearFirst = false,
    CompareCoinRef? selectedSecond,
    bool clearSecond = false,
    CompareTimeframe? timeframe,
    CompareResult? result,
    bool clearResult = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CompareState(
      status: status ?? this.status,
      selectedFirst: clearFirst ? null : (selectedFirst ?? this.selectedFirst),
      selectedSecond: clearSecond
          ? null
          : (selectedSecond ?? this.selectedSecond),
      timeframe: timeframe ?? this.timeframe,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedFirst,
    selectedSecond,
    timeframe,
    result,
    errorMessage,
  ];
}
