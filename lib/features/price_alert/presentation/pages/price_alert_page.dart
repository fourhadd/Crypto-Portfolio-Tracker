// features/alerts/presentation/pages/price_alerts_page.dart
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_cubit.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_state.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/widgets/create_alert_button.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/widgets/create_alert_sheet.dart';
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/widgets/price_alerts_list.dart';
import 'package:crypto_portfolio_tracker/features/market/presentation/cubit/market_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import '../../../settings/presentation/widgets/settings_app_bar.dart';

class PriceAlertsPage extends StatelessWidget {
  const PriceAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              const Row(
                children: [
                  Expanded(child: SettingsAppBar(title: 'Price Alerts')),
                  CreateAlertButton(),
                ],
              ),
              SizedBox(height: 24.h),
              const Expanded(child: PriceAlertsList()),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceAlertsSheetListener extends StatelessWidget {
  final Widget child;

  const PriceAlertsSheetListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PriceAlertsCubit, PriceAlertsState>(
      listenWhen: (prev, curr) =>
          prev.isCreateSheetOpen != curr.isCreateSheetOpen,
      listener: (context, state) {
        if (state.isCreateSheetOpen) {
          showModalBottomSheet(
            context: context,
            backgroundColor: AppColors.bgElevated,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<PriceAlertsCubit>()),
                BlocProvider.value(value: context.read<MarketCubit>()),
              ],
              child: const CreateAlertSheet(),
            ),
          ).whenComplete(
            () => context.read<PriceAlertsCubit>().closeCreateSheet(),
          );
        }
      },
      child: child,
    );
  }
}
