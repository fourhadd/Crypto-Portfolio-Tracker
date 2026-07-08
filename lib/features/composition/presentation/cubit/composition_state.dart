// features/composition/presentation/cubit/composition_state.dart
enum CompositionMode { byValue, byCount }

class CompositionState {
  final CompositionMode mode;

  const CompositionState({this.mode = CompositionMode.byValue});

  CompositionState copyWith({CompositionMode? mode}) {
    return CompositionState(mode: mode ?? this.mode);
  }
}
