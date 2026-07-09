// features/alerts/presentation/widgets/create_alert_button.dart
import 'package:crypto_portfolio_tracker/features/price_alert/presentation/cubit/price_alert_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class CreateAlertButton extends StatelessWidget {
  const CreateAlertButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<PriceAlertsCubit>().openCreateSheet(),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: 40.w,
        height: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.accentAmber, width: 1),
        ),
        child: Icon(Icons.add, size: 20.sp, color: AppColors.accentAmber),
      ),
    );
  }
}
