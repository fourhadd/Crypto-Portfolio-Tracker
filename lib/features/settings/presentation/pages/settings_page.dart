// features/settings/presentation/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import '../widgets/settings_app_bar.dart';
import '../widgets/settings_about_footer.dart';
import '../widgets/settings_about_section.dart';
import '../widgets/settings_alerts_section.dart';
import '../widgets/settings_data_section.dart';
import '../widgets/settings_general_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              SizedBox(height: 8.h),
              const SettingsAppBar(title: 'Settings'),
              SizedBox(height: 24.h),
              const SettingsGeneralSection(),
              SizedBox(height: 24.h),
              const SettingsAlertsSection(),
              SizedBox(height: 24.h),
              const SettingsDataSection(),
              SizedBox(height: 24.h),
              const SettingsAboutSection(),
              SizedBox(height: 32.h),
              const SettingsAboutFooter(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
