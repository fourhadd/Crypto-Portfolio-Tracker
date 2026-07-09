// features/settings/presentation/widgets/settings_general_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import 'settings_section.dart';
import 'settings_tile.dart';
import 'settings_option_tile.dart';

const List<String> kCurrencyOptions = [
  'USD',
  'EUR',
  'GBP',
  'JPY',
  'BTC',
  'ETH',
];

const Map<String, int> kRefreshIntervalOptions = {
  '10 seconds': 10,
  '30 seconds': 30,
  '1 minute': 60,
  '5 minutes': 300,
};

/// GENERAL bölməsi: Currency və Refresh Interval seçimləri.
/// Açılıb-bağlanma vəziyyəti SettingsCubit-də saxlanılır, bu widget
/// yalnız həmin vəziyyəti göstərir (Stateless).
class SettingsGeneralSection extends StatelessWidget {
  const SettingsGeneralSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (prev, curr) =>
          prev.currency != curr.currency ||
          prev.refreshIntervalSeconds != curr.refreshIntervalSeconds ||
          prev.isCurrencyPickerOpen != curr.isCurrencyPickerOpen ||
          prev.isRefreshPickerOpen != curr.isRefreshPickerOpen,
      builder: (context, state) {
        final refreshLabel = kRefreshIntervalOptions.entries
            .firstWhere(
              (e) => e.value == state.refreshIntervalSeconds,
              orElse: () =>
                  MapEntry('${state.refreshIntervalSeconds} seconds', 0),
            )
            .key;
        final cubit = context.read<SettingsCubit>();

        return SettingsSection(
          title: 'GENERAL',
          children: [
            SettingsTile(
              icon: Icons.language,
              title: 'Currency',
              trailingText: state.currency,
              trailingIcon: state.isCurrencyPickerOpen
                  ? Icons.keyboard_arrow_up
                  : Icons.chevron_right,
              onTap: cubit.toggleCurrencyPicker,
            ),
            if (state.isCurrencyPickerOpen)
              for (final option in kCurrencyOptions)
                SettingsOptionTile(
                  label: option,
                  selected: option == state.currency,
                  onTap: () => cubit.setCurrency(option),
                ),
            SettingsTile(
              icon: Icons.refresh,
              title: 'Refresh Interval',
              trailingText: refreshLabel,
              trailingIcon: state.isRefreshPickerOpen
                  ? Icons.keyboard_arrow_up
                  : Icons.chevron_right,
              onTap: cubit.toggleRefreshPicker,
            ),
            if (state.isRefreshPickerOpen)
              for (final entry in kRefreshIntervalOptions.entries)
                SettingsOptionTile(
                  label: entry.key,
                  selected: entry.value == state.refreshIntervalSeconds,
                  onTap: () => cubit.setRefreshInterval(entry.value),
                ),
          ],
        );
      },
    );
  }
}
