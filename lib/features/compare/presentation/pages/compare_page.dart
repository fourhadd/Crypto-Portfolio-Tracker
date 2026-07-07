// features/compare/presentation/pages/compare_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import '../widgets/coin_selector_row.dart';
import '../widgets/timeframe_selector.dart';
import '../widgets/compare_chart_card.dart';
import '../widgets/comparison_stats_card.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Compare', style: AppTextStyles.headingLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CoinSelectorRow(),
              SizedBox(height: 20.h),
              const TimeframeSelector(),
              SizedBox(height: 20.h),
              const CompareChartCard(),
              SizedBox(height: 20.h),
              const ComparisonStatsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
