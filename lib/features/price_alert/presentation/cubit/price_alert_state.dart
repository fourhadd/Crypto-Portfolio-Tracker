// features/alerts/presentation/cubit/price_alerts_state.dart
import 'package:crypto_portfolio_tracker/features/price_alert/domain/entities/alert_entity.dart';
import 'package:equatable/equatable.dart';

class PriceAlertsState extends Equatable {
  final List<PriceAlert> alerts;
  final bool isCreateSheetOpen;

  const PriceAlertsState({
    this.alerts = const [],
    this.isCreateSheetOpen = false,
  });

  bool get isEmpty => alerts.isEmpty;

  PriceAlertsState copyWith({
    List<PriceAlert>? alerts,
    bool? isCreateSheetOpen,
  }) {
    return PriceAlertsState(
      alerts: alerts ?? this.alerts,
      isCreateSheetOpen: isCreateSheetOpen ?? this.isCreateSheetOpen,
    );
  }

  @override
  List<Object?> get props => [alerts, isCreateSheetOpen];
}
