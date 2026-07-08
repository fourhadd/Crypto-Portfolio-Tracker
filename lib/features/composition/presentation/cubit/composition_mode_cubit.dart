// features/composition/presentation/cubit/composition_mode_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'composition_state.dart';

class CompositionModeCubit extends Cubit<CompositionState> {
  CompositionModeCubit() : super(const CompositionState());

  void setByValue() => emit(state.copyWith(mode: CompositionMode.byValue));

  void setByCount() => emit(state.copyWith(mode: CompositionMode.byCount));
}
