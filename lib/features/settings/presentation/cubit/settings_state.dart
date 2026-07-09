// features/settings/presentation/cubit/settings_state.dart
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String currency;
  final int refreshIntervalSeconds;
  final bool notificationsEnabled;
  final bool isExportingCsv;
  final bool isCurrencyPickerOpen;
  final bool isRefreshPickerOpen;

  const SettingsState({
    required this.currency,
    required this.refreshIntervalSeconds,
    required this.notificationsEnabled,
    this.isExportingCsv = false,
    this.isCurrencyPickerOpen = false,
    this.isRefreshPickerOpen = false,
  });

  factory SettingsState.initial() => const SettingsState(
    currency: 'USD',
    refreshIntervalSeconds: 30,
    notificationsEnabled: false,
  );

  SettingsState copyWith({
    String? currency,
    int? refreshIntervalSeconds,
    bool? notificationsEnabled,
    bool? isExportingCsv,
    bool? isCurrencyPickerOpen,
    bool? isRefreshPickerOpen,
  }) {
    return SettingsState(
      currency: currency ?? this.currency,
      refreshIntervalSeconds:
          refreshIntervalSeconds ?? this.refreshIntervalSeconds,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isExportingCsv: isExportingCsv ?? this.isExportingCsv,
      isCurrencyPickerOpen: isCurrencyPickerOpen ?? this.isCurrencyPickerOpen,
      isRefreshPickerOpen: isRefreshPickerOpen ?? this.isRefreshPickerOpen,
    );
  }

  @override
  List<Object?> get props => [
    currency,
    refreshIntervalSeconds,
    notificationsEnabled,
    isExportingCsv,
    isCurrencyPickerOpen,
    isRefreshPickerOpen,
  ];
}
