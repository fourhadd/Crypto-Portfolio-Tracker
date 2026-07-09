// features/settings/presentation/widgets/settings_about_section.dart
import 'package:flutter/material.dart';

import 'settings_section.dart';
import 'settings_tile.dart';

/// ABOUT bölməsi — statik məlumat, Cubit-ə ehtiyac yoxdur.
class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSection(
      title: 'ABOUT',
      children: [
        SettingsTile(
          icon: Icons.info_outline,
          title: 'Version',
          trailingText: '1.0.0',
        ),
        SettingsTile(
          icon: Icons.warning_amber_rounded,
          title: 'Data Source',
          trailingText: 'CoinGecko',
        ),
      ],
    );
  }
}
