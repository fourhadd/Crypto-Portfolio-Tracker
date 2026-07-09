// features/composition/presentation/pages/composition_page.dart
import 'package:crypto_portfolio_tracker/features/composition/presentation/widgets/composition_donut_chart.dart';
import 'package:crypto_portfolio_tracker/features/composition/presentation/widgets/composition_list.dart';
import 'package:crypto_portfolio_tracker/features/composition/presentation/widgets/composition_toggle.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:crypto_portfolio_tracker/features/portfolio/presentation/cubit/portfolio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import '../cubit/composition_mode_cubit.dart';
import '../cubit/composition_state.dart';

class CompositionPage extends StatelessWidget {
  const CompositionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompositionModeCubit(),
      child: Scaffold(
        backgroundColor: AppColors.bgBase,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Row(
                  children: [
                    InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.bgElevated,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.bgElevatedBorder,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textPrimary,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Text(
                      'Composition',
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 24.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                const CompositionToggle(),
                SizedBox(height: 28.h),
                BlocBuilder<PortfolioCubit, PortfolioState>(
                  buildWhen: (prev, curr) =>
                      prev.status != curr.status || prev.items != curr.items,
                  builder: (context, state) {
                    if (state.status != PortfolioStatus.loaded ||
                        state.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 60.h),
                        child: Center(
                          child: Text(
                            'No holdings to show',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      );
                    }

                    return BlocBuilder<CompositionModeCubit, CompositionState>(
                      builder: (context, compositionState) {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CompositionDonutChart(
                                  items: state.items,
                                  mode: compositionState.mode,
                                ),
                                SizedBox(height: 28.h),
                                CompositionList(
                                  items: state.items,
                                  mode: compositionState.mode,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
