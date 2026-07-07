// features/portfolio/presentation/widgets/purchase_date_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

import '../cubit/add_holding_cubit.dart';
import '../cubit/add_holding_state.dart';

class PurchaseDateField extends StatelessWidget {
  const PurchaseDateField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddHoldingCubit, AddHoldingState>(
      buildWhen: (prev, curr) => prev.buyDate != curr.buyDate,
      builder: (context, state) {
        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.chip),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: state.buyDate,
              firstDate: DateTime(2009),
              lastDate: DateTime.now(),
            );
            if (picked != null && context.mounted) {
              context.read<AddHoldingCubit>().updateBuyDate(picked);
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(AppRadius.chip),
              border: Border.all(color: AppColors.glassBorder, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd.MM.yyyy').format(state.buyDate),
                  style: AppTextStyles.bodyLarge,
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.textSecondary,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
