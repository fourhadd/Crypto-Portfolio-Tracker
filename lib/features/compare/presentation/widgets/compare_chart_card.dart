// features/compare/presentation/widgets/compare_chart_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import '../cubit/compare_cubit.dart';
import '../cubit/compare_state.dart';
import 'compare_line_chart.dart';
import 'chart_legend.dart';
import '../../../../core/shared/widgets/core_network_error_view.dart';

class CompareChartCard extends StatelessWidget {
  const CompareChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: AppGlass.decoration(),
      child: BlocBuilder<CompareCubit, CompareState>(
        buildWhen: (prev, curr) =>
            prev.status != curr.status || prev.result != curr.result,
        builder: (context, state) {
          switch (state.status) {
            case CompareStatus.loading:
              return SizedBox(
                height: 220.h,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accentAmber,
                  ),
                ),
              );

            case CompareStatus.error:
              return SizedBox(
                height: 220.h,
                child: CoreNetworkErrorView(
                  message: state.errorMessage,
                  onRetry: () => context.read<CompareCubit>().refresh(),
                  padding: EdgeInsets.zero,
                ),
              );

            case CompareStatus.loaded:
              if (state.result == null) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChartLegend(
                    firstSymbol: state.result!.first.symbol,
                    secondSymbol: state.result!.second.symbol,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 220.h,
                    width: double.infinity,
                    child: CompareLineChart(result: state.result!),
                  ),
                ],
              );

            case CompareStatus.idle:
              return SizedBox(
                height: 220.h,
                child: Center(
                  child: Text(
                    'Müqayisə üçün 2 coin seçin',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
