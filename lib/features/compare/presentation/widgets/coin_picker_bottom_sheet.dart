// features/compare/presentation/widgets/coin_picker_bottom_sheet.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';
import 'package:crypto_portfolio_tracker/core/domain/entities/coin_entity.dart';
import 'package:crypto_portfolio_tracker/features/market/presentation/cubit/market_cubit.dart';
import 'package:crypto_portfolio_tracker/features/market/presentation/cubit/market_state.dart';

class CoinPickerBottomSheet extends StatefulWidget {
  const CoinPickerBottomSheet({super.key});

  static Future<CoinEntity?> show(BuildContext context) {
    final marketCubit = context.read<MarketCubit>();

    return showModalBottomSheet<CoinEntity>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider<MarketCubit>.value(
        value: marketCubit,
        child: const CoinPickerBottomSheet(),
      ),
    );
  }

  @override
  State<CoinPickerBottomSheet> createState() => _CoinPickerBottomSheetState();
}

class _CoinPickerBottomSheetState extends State<CoinPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgBase,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.sheet),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
          border: Border.all(color: AppColors.bgElevatedBorder, width: 1),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text('Coin seç', style: AppTextStyles.headingMedium),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _searchController,
                    style: AppTextStyles.bodyMedium,
                    onChanged: (value) =>
                        setState(() => _query = value.trim().toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Coin adı və ya simvol axtar',
                      hintStyle: AppTextStyles.bodySmall,
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                        size: 20.sp,
                      ),
                      filled: true,
                      fillColor: AppColors.bgElevated,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                        borderSide: BorderSide(color: AppColors.glassBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                        borderSide: BorderSide(color: AppColors.glassBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                        borderSide: const BorderSide(
                          color: AppColors.accentAmber,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: BlocBuilder<MarketCubit, MarketState>(
                      buildWhen: (prev, curr) =>
                          curr.status == MarketStatus.loaded ||
                          curr.status == MarketStatus.error,
                      builder: (context, state) {
                        if (state.status == MarketStatus.error) {
                          return Center(
                            child: Text(
                              state.errorMessage ?? 'Xəta baş verdi',
                              style: AppTextStyles.bodySmall,
                            ),
                          );
                        }

                        if (state.status != MarketStatus.loaded) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.accentAmber,
                            ),
                          );
                        }

                        final filtered = _query.isEmpty
                            ? state.coins
                            : state.coins.where((coin) {
                                return coin.name.toLowerCase().contains(
                                      _query,
                                    ) ||
                                    coin.symbol.toLowerCase().contains(_query);
                              }).toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Text(
                              'Nəticə tapılmadı',
                              style: AppTextStyles.bodySmall,
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final coin = filtered[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () => Navigator.of(context).pop(coin),
                              leading: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: coin.image,
                                  width: 32.w,
                                  height: 32.h,
                                  placeholder: (_, __) =>
                                      SizedBox(width: 32.w, height: 32.h),
                                  errorWidget: (_, __, ___) => Icon(
                                    Icons.currency_bitcoin,
                                    size: 32.w,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              title: Text(
                                coin.name,
                                style: AppTextStyles.bodyMedium,
                              ),
                              subtitle: Text(
                                coin.symbol.toUpperCase(),
                                style: AppTextStyles.bodySmall,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
