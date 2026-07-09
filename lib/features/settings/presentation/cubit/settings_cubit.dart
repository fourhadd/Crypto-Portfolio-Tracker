// features/settings/presentation/cubit/settings_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/sevices/storage_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final StorageService storageService;

  SettingsCubit({required this.storageService})
    : super(SettingsState.initial()) {
    _loadSettings();
  }

  void _loadSettings() {
    final currency =
        storageService.readValue<String>(AppConstants.storageKeyCurrency) ??
        state.currency;
    final refreshInterval =
        storageService.readValue<int>(AppConstants.storageKeyRefreshInterval) ??
        state.refreshIntervalSeconds;
    final notificationsEnabled =
        storageService.readValue<bool>(
          AppConstants.storageKeyNotificationsEnabled,
        ) ??
        state.notificationsEnabled;

    emit(
      state.copyWith(
        currency: currency,
        refreshIntervalSeconds: refreshInterval,
        notificationsEnabled: notificationsEnabled,
      ),
    );
  }

  void setCurrency(String currency) {
    storageService.writeValue(AppConstants.storageKeyCurrency, currency);
    emit(state.copyWith(currency: currency, isCurrencyPickerOpen: false));
  }

  void setRefreshInterval(int seconds) {
    storageService.writeValue(AppConstants.storageKeyRefreshInterval, seconds);
    emit(
      state.copyWith(
        refreshIntervalSeconds: seconds,
        isRefreshPickerOpen: false,
      ),
    );
  }

  void toggleNotifications(bool enabled) {
    storageService.writeValue(
      AppConstants.storageKeyNotificationsEnabled,
      enabled,
    );
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  void setExporting(bool exporting) {
    emit(state.copyWith(isExportingCsv: exporting));
  }

  void toggleCurrencyPicker() {
    final willOpen = !state.isCurrencyPickerOpen;
    emit(
      state.copyWith(
        isCurrencyPickerOpen: willOpen,
        isRefreshPickerOpen: willOpen ? false : state.isRefreshPickerOpen,
      ),
    );
  }

  void toggleRefreshPicker() {
    final willOpen = !state.isRefreshPickerOpen;
    emit(
      state.copyWith(
        isRefreshPickerOpen: willOpen,
        isCurrencyPickerOpen: willOpen ? false : state.isCurrencyPickerOpen,
      ),
    );
  }
}
