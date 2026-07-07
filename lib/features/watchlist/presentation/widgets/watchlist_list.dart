// features/watchlist/presentation/widgets/watchlist_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/watchlist_coin_entity.dart';
import 'watchlist_list_item.dart';

class WatchlistList extends StatelessWidget {
  final List<WatchlistCoinEntity> coins;

  const WatchlistList({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: coins.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = coins[index];
        return WatchlistListItem(key: ValueKey(item.coin.id), item: item);
      },
    );
  }
}
