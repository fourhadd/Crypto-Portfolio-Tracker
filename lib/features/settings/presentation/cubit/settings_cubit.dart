// features/settings/presentation/cubit/settings_cubit.dart
import 'package:crypto_portfolio_tracker/core/sevices/currency_notifier_service.dart';
import 'package:crypto_portfolio_tracker/core/sevices/refresh_interval_notifier_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/sevices/storage_service.dart';
import '../../../../core/utils/number_formatter.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final StorageService storageService;
  final CurrencyNotifierService currencyNotifier;
  final RefreshIntervalNotifierService refreshIntervalNotifier;

  SettingsCubit({
    required this.storageService,
    required this.currencyNotifier,
    required this.refreshIntervalNotifier,
  }) : super(SettingsState.initial()) {
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

    NumberFormatter.updateCurrency(currency);
  }

  void setCurrency(String currency) {
    storageService.writeValue(AppConstants.storageKeyCurrency, currency);

    emit(state.copyWith(currency: currency, isCurrencyPickerOpen: false));

    NumberFormatter.updateCurrency(currency);
    currencyNotifier.notify(currency.toLowerCase());
  }

  void setRefreshInterval(int seconds) {
    storageService.writeValue(AppConstants.storageKeyRefreshInterval, seconds);

    emit(
      state.copyWith(
        refreshIntervalSeconds: seconds,
        isRefreshPickerOpen: false,
      ),
    );

    refreshIntervalNotifier.notify(seconds);
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
