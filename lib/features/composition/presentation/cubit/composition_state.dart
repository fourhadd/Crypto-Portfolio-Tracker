import 'package:equatable/equatable.dart';

enum CompositionMode { byValue, byCount }

class CompositionState extends Equatable {
  final CompositionMode mode;

  const CompositionState({this.mode = CompositionMode.byValue});

  CompositionState copyWith({CompositionMode? mode}) {
    return CompositionState(mode: mode ?? this.mode);
  }

  @override
  List<Object?> get props => [mode];
}
