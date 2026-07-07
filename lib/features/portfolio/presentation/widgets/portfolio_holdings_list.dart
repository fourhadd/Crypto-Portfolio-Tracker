// features/portfolio/presentation/widgets/portfolio_holdings_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/portfolio_coin_entity.dart';
import 'portfolio_holding_tile.dart';

class PortfolioHoldingsList extends StatelessWidget {
  final List<PortfolioCoinEntity> items;

  const PortfolioHoldingsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => PortfolioHoldingTile(item: items[index]),
    );
  }
}
