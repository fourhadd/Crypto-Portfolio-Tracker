// features/alerts/presentation/cubit/price_alerts_cubit.dart
//
// Polls prices via MarketCubit and fires local notifications when an
// active alert's target price is crossed. Once fired, the alert is
// deactivated (not deleted) so it won't re-fire until re-toggled on.
// Checking only runs while there's at least one active alert, and
// respects the notificationsEnabled flag in storage.
//
// Note: relies on MarketCubit's own polling instead of fetching
// independently, so an alert on a coin outside MarketCubit's top-100
// won't be checked until that page size changes.
import 'dart:async';
import 'dart:convert';

import 'package:crypto_portfolio_tracker/core/constants/app_constants.dart';
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';
import 'package:crypto_portfolio_tracker/core/sevices/notification_service.dart';
import 'package:crypto_portfolio_tracker/features/market/presentation/cubit/market_cubit.dart';
import 'package:crypto_portfolio_tracker/features/market/presentation/cubit/market_state.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/domain/entities/alert_entity.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/sevices/storage_service.dart';

const String kStorageKeyPriceAlerts = 'price_alerts';

class PriceAlertsCubit extends Cubit<PriceAlertsState> {
  final StorageService storageService;
  final MarketCubit marketCubit;
  final NotificationService notificationService;

  StreamSubscription<MarketState>? _marketSubscription;
  bool _isChecking = false;

  PriceAlertsCubit({
    required this.storageService,
    required this.marketCubit,
    required this.notificationService,
  }) : super(const PriceAlertsState()) {
    _load();
    _syncWatching();
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
      // Corrupted data - ignore it.
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
    required String coinId,
    required String symbol,
    required double targetPrice,
    required AlertCondition condition,
  }) {
    final alert = PriceAlert(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      symbol: symbol.toUpperCase(),
      coinId: coinId,
      targetPrice: targetPrice,
      condition: condition,
    );
    final updated = [...state.alerts, alert];
    emit(state.copyWith(alerts: updated, isCreateSheetOpen: false));
    _persist(updated);
    _syncWatching();
  }

  void removeAlert(String id) {
    final updated = state.alerts.where((a) => a.id != id).toList();
    emit(state.copyWith(alerts: updated));
    _persist(updated);
    _syncWatching();
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
    _syncWatching();
  }

  /// Starts or stops listening to MarketCubit depending on whether
  /// there's anything worth watching. Never issues its own network
  /// request - only asks MarketCubit to fetch if needed, then reacts
  /// to whatever it emits.
  void _syncWatching() {
    final hasActiveAlerts = state.alerts.any((a) => a.isActive);

    if (hasActiveAlerts) {
      _marketSubscription ??= marketCubit.stream.listen((marketState) {
        _checkAlerts(marketState.allCoins);
      });
      marketCubit.fetchIfNeeded();
      if (marketCubit.state.status == MarketStatus.loaded) {
        _checkAlerts(marketCubit.state.allCoins);
      }
    } else {
      _marketSubscription?.cancel();
      _marketSubscription = null;
    }
  }

  Future<void> _checkAlerts(List<CoinEntity> coins) async {
    if (_isChecking || isClosed) return;
    final activeAlerts = state.alerts.where((a) => a.isActive).toList();
    if (activeAlerts.isEmpty || coins.isEmpty) return;

    _isChecking = true;
    try {
      final triggeredIds = <String>{};
      final armedUpdates = <String, double>{}; // id -> new lastKnownPrice

      for (final alert in activeAlerts) {
        // Prefer matching by coin id - symbols aren't unique on
        // CoinGecko (several coins can share the same ticker), so an
        // alert on e.g. "SOL" could otherwise silently track the wrong
        // coin. Alerts created before this field existed have no
        // coinId, so they fall back to the old symbol match.
        final coin = alert.coinId != null
            ? _firstWhereOrNull(coins, (c) => c.id == alert.coinId)
            : _firstWhereOrNull(
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
        if (isClosed) return;
        emit(state.copyWith(alerts: updated));
        _persist(updated);
        _syncWatching();
      }
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
  Future<void> close() async {
    await _marketSubscription?.cancel();
    return super.close();
  }
}
