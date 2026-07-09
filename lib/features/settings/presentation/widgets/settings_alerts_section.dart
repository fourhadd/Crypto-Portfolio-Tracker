// features/settings/presentation/widgets/settings_alerts_section.dart
import 'package:crypto_portfolio_tracker/features/settings/presentation/widgets/settings_switch_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import 'settings_section.dart';
import 'settings_tile.dart';

class SettingsAlertsSection extends StatelessWidget {
  const SettingsAlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'ALERTS',
      children: [
        SettingsTile(
          icon: Icons.notifications_none,
          title: 'Price Alerts',
          onTap: () => context.push('/price-alerts'),
        ),
        BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (prev, curr) =>
              prev.notificationsEnabled != curr.notificationsEnabled,
          builder: (context, state) {
            return SettingsSwitchTile(
              icon: Icons.notifications_none,
              title: 'Notifications',
              value: state.notificationsEnabled,
              onChanged: (v) =>
                  context.read<SettingsCubit>().toggleNotifications(v),
            );
          },
        ),
      ],
    );
  }
}
