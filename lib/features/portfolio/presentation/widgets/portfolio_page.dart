// features/portfolio/presentation/widgets/portfolio_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/portfolio_app_bar.dart';
import '../widgets/portfolio_total_value_card.dart';
import '../widgets/portfolio_body.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              const PortfolioAppBar(),
              SizedBox(height: 20.h),
              const PortfolioTotalValueCard(),
              SizedBox(height: 32.h),
              const Expanded(child: PortfolioBody()),
            ],
          ),
        ),
      ),
    );
  }
}
