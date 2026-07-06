// features/onboarding/presentation/widgets/onboarding_slide_data.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OnboardingSlideData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const OnboardingSlideData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
}

const List<OnboardingSlideData> onboardingSlides = [
  OnboardingSlideData(
    icon: Icons.trending_up_rounded,
    iconColor: AppColors.accentAmber,
    title: 'Portfelini İzlə',
    description:
        'Bütün kripto aktivlərini bir yerdə izlə — real-time qiymət və mənfəət/zərər hesablaması ilə.',
  ),
  OnboardingSlideData(
    icon: Icons.shield_outlined,
    iconColor: AppColors.positive,
    title: 'Məlumatın, Məxfi',
    description:
        'Hər şey cihazında lokal saxlanılır. Hesab yoxdur, server yoxdur, güzəşt yoxdur.',
  ),
  OnboardingSlideData(
    icon: Icons.notifications_none_rounded,
    iconColor: AppColors.chartSecondary,
    title: 'Ağıllı Bildirişlər',
    description:
        'Qiymət alert-ləri qur, coin-lər hədəf qiymətə çatanda dərhal xəbərdar ol.',
  ),
];
