// features/alerts/presentation/widgets/price_alerts_list.dart
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_cubit.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'price_alert_card.dart';
import 'price_alerts_empty_view.dart';

class PriceAlertsList extends StatelessWidget {
  const PriceAlertsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PriceAlertsCubit, PriceAlertsState>(
      buildWhen: (prev, curr) => prev.alerts != curr.alerts,
      builder: (context, state) {
        if (state.isEmpty) return const PriceAlertsEmptyView();

        return ListView.separated(
          itemCount: state.alerts.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) =>
              PriceAlertCard(alert: state.alerts[index]),
        );
      },
    );
  }
}
