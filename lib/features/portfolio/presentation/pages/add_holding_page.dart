// features/portfolio/presentation/pages/add_holding_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

import '../cubit/add_holding_cubit.dart';
import '../cubit/add_holding_state.dart';
import '../widgets/add_holding_header.dart';
import '../widgets/coin_select_field.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/purchase_date_field.dart';
import '../widgets/save_holding_button.dart';
import '../widgets/use_current_price_hint.dart';
import '../widgets/total_cost_card.dart';

class AddHoldingPage extends StatelessWidget {
  const AddHoldingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AddHoldingCubit, AddHoldingState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == AddHoldingStatus.success) {
              context.pop();
            } else if (state.status == AddHoldingStatus.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage ?? '')));
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                const AddHoldingHeader(),
                SizedBox(height: 24.h),
                Text('COIN', style: AppTextStyles.microLabel),
                SizedBox(height: 8.h),
                const CoinSelectField(),
                SizedBox(height: 20.h),
                Text('QUANTITY', style: AppTextStyles.microLabel),
                SizedBox(height: 8.h),
                LabeledTextField(
                  hint: '0.00',
                  onChanged: (v) =>
                      context.read<AddHoldingCubit>().updateQuantity(v),
                ),
                SizedBox(height: 20.h),
                Text('BUY PRICE (USD)', style: AppTextStyles.microLabel),
                SizedBox(height: 8.h),
                BlocBuilder<AddHoldingCubit, AddHoldingState>(
                  buildWhen: (prev, curr) => prev.buyPrice != curr.buyPrice,
                  builder: (context, state) {
                    return LabeledTextField(
                      hint: '0.00',
                      text: state.buyPrice?.toStringAsFixed(2),
                      onChanged: (v) =>
                          context.read<AddHoldingCubit>().updateBuyPrice(v),
                    );
                  },
                ),
                const UseCurrentPriceHint(),
                SizedBox(height: 20.h),
                Text('PURCHASE DATE', style: AppTextStyles.microLabel),
                SizedBox(height: 8.h),
                const PurchaseDateField(),
                const TotalCostCard(),
                SizedBox(height: 28.h),
                const SaveHoldingButton(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
