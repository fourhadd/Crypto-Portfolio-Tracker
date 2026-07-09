// features/alerts/presentation/cubit/price_alerts_cubit.dart
//
// Fix (finding #18, Phase 6): this cubit now actually polls prices and
// fires local notifications instead of only persisting alert records.
// Every `_pollInterval` it fetches the top coins, checks each *active*
// alert's symbol/condition/targetPrice against the current price, and
// fires a local notification the moment the price crosses the target.
// Once fired, the alert is deactivated (not deleted) so it won't spam
// the user again - they can re-toggle it on to watch for another
// crossing. Polling only runs while there's at least one active alert,
// and respects SettingsCubit's notificationsEnabled flag (read straight
// from storage so this cubit doesn't need to depend on SettingsCubit).
import 'dart:async';
import 'dart:convert';

import 'package:crypto_portfolio_tracker/core/constants/app_constants.dart';
import 'package:crypto_portfolio_tracker/core/domain/usecases/get_top_coins_usecase.dart';
import 'package:crypto_portfolio_tracker/core/sevices/notification_service.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/domain/entities/alert_entity.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/sevices/storage_service.dart';

const String kStorageKeyPriceAlerts = 'price_alerts';

class PriceAlertsCubit extends Cubit<PriceAlertsState> {
  final StorageService storageService;
  final GetTopCoinsUseCase getTopCoinsUseCase;
  final NotificationService notificationService;

  static const Duration _pollInterval = Duration(seconds: 30);

  Timer? _pollTimer;
  bool _isChecking = false;

  PriceAlertsCubit({
    required this.storageService,
    required this.getTopCoinsUseCase,
    required this.notificationService,
  }) : super(const PriceAlertsState()) {
    _load();
    _syncPolling();
  }

  void _load() {
    final raw = storageService.readValue<String>(kStorageKeyPriceAlerts);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final alerts = decoded
          .map((e) => PriceAlert.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(state.copyWith(alerts: alerts));
    } catch (_) {
      // Korlanmış data - saymırıq.
    }
  }

  void _persist(List<PriceAlert> alerts) {
    storageService.writeValue(
      kStorageKeyPriceAlerts,
      jsonEncode(alerts.map((a) => a.toJson()).toList()),
    );
  }

  bool get _notificationsEnabled =>
      storageService.readValue<bool>(
        AppConstants.storageKeyNotificationsEnabled,
      ) ??
      false;

  void openCreateSheet() => emit(state.copyWith(isCreateSheetOpen: true));

  void closeCreateSheet() => emit(state.copyWith(isCreateSheetOpen: false));

  void addAlert({
    required String symbol,
    required double targetPrice,
    required AlertCondition condition,
  }) {
    final alert = PriceAlert(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      symbol: symbol.toUpperCase(),
      targetPrice: targetPrice,
      condition: condition,
    );
    final updated = [...state.alerts, alert];
    emit(state.copyWith(alerts: updated, isCreateSheetOpen: false));
    _persist(updated);
    _syncPolling();
  }

  void removeAlert(String id) {
    final updated = state.alerts.where((a) => a.id != id).toList();
    emit(state.copyWith(alerts: updated));
    _persist(updated);
    _syncPolling();
  }

  void toggleAlert(String id, bool isActive) {
    final updated = state.alerts
        .map(
          (a) => a.id == id
              ? a.copyWith(
                  isActive: isActive,
                  // Re-arm: forget the old baseline so turning an alert
                  // back on doesn't instantly fire just because price
                  // already sits past the target - it should only fire
                  // on the next real crossing.
                  clearLastKnownPrice: true,
                )
              : a,
        )
        .toList();
    emit(state.copyWith(alerts: updated));
    _persist(updated);
    _syncPolling();
  }

  /// Starts or stops the polling timer depending on whether there's
  /// anything worth watching. Cheap to call after every mutation.
  void _syncPolling() {
    final hasActiveAlerts = state.alerts.any((a) => a.isActive);

    if (hasActiveAlerts && _pollTimer == null) {
      _checkAlerts();
      _pollTimer = Timer.periodic(_pollInterval, (_) => _checkAlerts());
    } else if (!hasActiveAlerts && _pollTimer != null) {
      _pollTimer?.cancel();
      _pollTimer = null;
    }
  }

  Future<void> _checkAlerts() async {
    if (_isChecking) return;
    final activeAlerts = state.alerts.where((a) => a.isActive).toList();
    if (activeAlerts.isEmpty) return;

    _isChecking = true;
    try {
      final result = await getTopCoinsUseCase(
        vsCurrency: 'usd',
        page: 1,
        perPage: 250,
      );

      await result.fold(
        (_) async {
          // Silent failure - offline or rate-limited, try again next tick.
        },
        (coins) async {
          final triggeredIds = <String>{};
          final armedUpdates = <String, double>{}; // id -> new lastKnownPrice

          for (final alert in activeAlerts) {
            final coin = _firstWhereOrNull(
              coins,
              (c) => c.symbol.toUpperCase() == alert.symbol.toUpperCase(),
            );
            if (coin == null) continue;

            final currentPrice = coin.currentPrice;

            bool satisfies(double price) => alert.condition == AlertCondition.above
                ? price >= alert.targetPrice
                : price <= alert.targetPrice;

            if (alert.lastKnownPrice == null) {
              // First check since creation/re-enable: just arm the
              // baseline, never fire on this pass even if the price
              // already satisfies the condition.
              armedUpdates[alert.id] = currentPrice;
              continue;
            }

            final wasSatisfied = satisfies(alert.lastKnownPrice!);
            final isSatisfied = satisfies(currentPrice);
            final justCrossed = isSatisfied && !wasSatisfied;

            if (justCrossed) {
              triggeredIds.add(alert.id);
              if (_notificationsEnabled) {
                final direction = alert.condition == AlertCondition.above
                    ? 'üstünə çıxdı'
                    : 'altına düşdü';
                await notificationService.showPriceAlert(
                  id: alert.id.hashCode,
                  title: '${alert.symbol} qiymət xəbərdarlığı',
                  body:
                      '${alert.symbol} \$${currentPrice.toStringAsFixed(2)} - $direction (hədəf: \$${alert.targetPrice.toStringAsFixed(2)})',
                );
              }
            } else {
              armedUpdates[alert.id] = currentPrice;
            }
          }

          if (triggeredIds.isNotEmpty || armedUpdates.isNotEmpty) {
            final updated = state.alerts.map((a) {
              if (triggeredIds.contains(a.id)) {
                return a.copyWith(isActive: false, clearLastKnownPrice: true);
              }
              if (armedUpdates.containsKey(a.id)) {
                return a.copyWith(lastKnownPrice: armedUpdates[a.id]);
              }
              return a;
            }).toList();
            emit(state.copyWith(alerts: updated));
            _persist(updated);
            _syncPolling();
          }
        },
      );
    } finally {
      _isChecking = false;
    }
  }

  T? _firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
    for (final e in list) {
      if (test(e)) return e;
    }
    return null;
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    _pollTimer = null;
    return super.close();
  }
}
