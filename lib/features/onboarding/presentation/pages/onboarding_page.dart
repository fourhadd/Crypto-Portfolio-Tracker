// features/onboarding/presentation/pages/onboarding_page.dart
import 'package:crypto_portfolio_tracker/features/onboarding/presentation/widgets/onboarding_dots.dart';
import 'package:crypto_portfolio_tracker/features/onboarding/presentation/widgets/onboarding_slide.dart';
import 'package:crypto_portfolio_tracker/features/onboarding/presentation/widgets/onboarding_slide_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return BlocListener<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == OnboardingStatus.completed && context.mounted) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgBase,
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return Stack(
                children: [
                  PageView.builder(
                    controller: cubit.pageController,
                    itemCount: onboardingSlides.length,
                    onPageChanged: cubit.onPageChanged,
                    itemBuilder: (context, i) =>
                        OnboardingSlide(data: onboardingSlides[i]),
                  ),
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: 24.h + bottomSafe,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OnboardingDots(
                          count: state.totalSlides,
                          activeIndex: state.currentIndex,
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (state.isLastSlide) {
                                await cubit.nextOrFinish();
                                if (context.mounted) context.go('/home');
                              } else {
                                cubit.nextOrFinish();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentAmber,
                              foregroundColor: AppColors.bgBase,
                              shadowColor: AppColors.accentAmberGlow,
                              elevation: 12,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.button,
                                ),
                              ),
                            ),
                            child: Text(
                              state.isLastSlide ? 'Get Started' : 'Continue',
                              style: AppTextStyles.buttonText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
