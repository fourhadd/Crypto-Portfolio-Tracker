// features/compare/domain/entities/compare_coin_ref.dart
import 'package:equatable/equatable.dart';

class CompareCoinRef extends Equatable {
  final String id;
  final String symbol;
  final String image;

  const CompareCoinRef({
    required this.id,
    required this.symbol,
    required this.image,
  });

  @override
  List<Object?> get props => [id, symbol, image];
}
