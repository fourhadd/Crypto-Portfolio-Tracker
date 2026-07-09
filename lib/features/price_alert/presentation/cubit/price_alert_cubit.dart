// features/alerts/presentation/cubit/price_alerts_cubit.dart
import 'dart:convert';

import 'package:crypto_portfolio_tracker/features/price_alert/domain/entities/alert_entity.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/sevices/storage_service.dart';

const String kStorageKeyPriceAlerts = 'price_alerts';

class PriceAlertsCubit extends Cubit<PriceAlertsState> {
  final StorageService storageService;

  PriceAlertsCubit({required this.storageService})
    : super(const PriceAlertsState()) {
    _load();
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
  }

  void removeAlert(String id) {
    final updated = state.alerts.where((a) => a.id != id).toList();
    emit(state.copyWith(alerts: updated));
    _persist(updated);
  }

  void toggleAlert(String id, bool isActive) {
    final updated = state.alerts
        .map((a) => a.id == id ? a.copyWith(isActive: isActive) : a)
        .toList();
    emit(state.copyWith(alerts: updated));
    _persist(updated);
  }
}
