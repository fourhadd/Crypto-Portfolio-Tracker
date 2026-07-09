import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../domain/entities/watchlist_coin_entity.dart';
import '../cubit/watchlist_cubit.dart';
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

        return Slidable(
          key: ValueKey(item.coin.id),

          endActionPane: ActionPane(
            motion: const StretchMotion(),
            extentRatio: 0.28,
            children: [
              SlidableAction(
                onPressed: (_) {
                  context.read<WatchlistCubit>().removeCoin(item.coin.id);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                icon: Icons.delete_outline,
                label: 'Delete',
              ),
            ],
          ),

          child: WatchlistListItem(item: item),
        );
      },
    );
  }
}
