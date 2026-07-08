// features/portfolio/presentation/widgets/calendar/calendar_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime visibleMonth;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const CalendarHeader({
    super.key,
    required this.visibleMonth,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrevMonth,
          icon: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.textPrimary,
            size: 24.sp,
          ),
        ),
        Text(
          DateFormat('MMMM yyyy').format(visibleMonth),
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textPrimary,
            size: 24.sp,
          ),
        ),
      ],
    );
  }
}
