// features/onboarding/presentation/cubit/onboarding_state.dart
import 'package:equatable/equatable.dart';

enum OnboardingStatus { loading, inProgress, completed }

class OnboardingState extends Equatable {
  final OnboardingStatus status;
  final int currentIndex;
  final int totalSlides;

  const OnboardingState({
    required this.status,
    required this.currentIndex,
    required this.totalSlides,
  });

  factory OnboardingState.initial({required int totalSlides}) {
    return OnboardingState(
      status: OnboardingStatus.loading,
      currentIndex: 0,
      totalSlides: totalSlides,
    );
  }

  bool get isLastSlide => currentIndex == totalSlides - 1;

  OnboardingState copyWith({
    OnboardingStatus? status,
    int? currentIndex,
    int? totalSlides,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      totalSlides: totalSlides ?? this.totalSlides,
    );
  }

  @override
  List<Object?> get props => [status, currentIndex, totalSlides];
}
