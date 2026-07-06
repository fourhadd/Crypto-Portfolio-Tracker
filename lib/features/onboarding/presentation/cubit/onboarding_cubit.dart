// features/onboarding/presentation/cubit/onboarding_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/local_storage/storage_service.dart';
import '../widgets/onboarding_slide_data.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final StorageService storageService;

  final PageController pageController = PageController();

  OnboardingCubit({required this.storageService})
    : super(OnboardingState.initial(totalSlides: onboardingSlides.length));

  Future<void> checkOnboardingStatus() async {
    emit(state.copyWith(status: OnboardingStatus.inProgress));

    try {
      final seen =
          storageService.readValue<bool>(
            AppConstants.storageKeyOnboardingSeen,
          ) ??
          false;

      emit(
        state.copyWith(
          status: seen
              ? OnboardingStatus.completed
              : OnboardingStatus.inProgress,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: OnboardingStatus.inProgress));
    }
  }

  void onPageChanged(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> nextOrFinish() async {
    if (state.isLastSlide) {
      await _finish();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> skip() => _finish();

  Future<void> _finish() async {
    try {
      await storageService.writeValue(
        AppConstants.storageKeyOnboardingSeen,
        true,
      );
    } catch (_) {
    } finally {
      emit(state.copyWith(status: OnboardingStatus.completed));
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
