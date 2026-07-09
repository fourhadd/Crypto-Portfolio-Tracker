// features/market/presentation/pages/market_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/market_header.dart';
import '../widgets/market_search_field.dart';
import '../widgets/market_filter_chips.dart';
import '../widgets/market_coin_list_view.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    // MarketCubit is already provided (and fetched via fetchIfNeeded())
    // by the /market route in app_router.dart — no need to re-provide
    // or re-fetch here.
    return const _MarketView();
  }
}

class _MarketView extends StatelessWidget {
  const _MarketView();

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
              const MarketHeader(),
              SizedBox(height: 16.h),
              const MarketSearchField(),
              SizedBox(height: 16.h),
              const MarketFilterChips(),
              SizedBox(height: 8.h),
              const Expanded(child: MarketCoinListView()),
            ],
          ),
        ),
      ),
    );
  }
}
