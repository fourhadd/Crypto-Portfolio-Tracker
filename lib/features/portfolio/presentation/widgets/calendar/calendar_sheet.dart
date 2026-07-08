// features/portfolio/presentation/widgets/calendar/calendar_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

import 'calendar_header.dart';
import 'calendar_grid.dart';
import 'calendar_actions.dart';

class CalendarSheet extends StatefulWidget {
  final DateTime initialDate;

  const CalendarSheet({super.key, required this.initialDate});

  @override
  State<CalendarSheet> createState() => _CalendarSheetState();
}

class _CalendarSheetState extends State<CalendarSheet> {
  late DateTime _visibleMonth;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
    _visibleMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  void _selectDate(DateTime date) {
    setState(() => _selected = date);
  }

  @override
  Widget build(BuildContext context) {
    final solidBackground = Color.alphaBlend(
      AppColors.bgElevated,
      AppColors.bgBase,
    );

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: solidBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(color: AppColors.bgElevatedBorder, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 20.h),
          CalendarHeader(
            visibleMonth: _visibleMonth,
            onPrevMonth: () => _changeMonth(-1),
            onNextMonth: () => _changeMonth(1),
          ),
          SizedBox(height: 8.h),
          CalendarGrid(
            visibleMonth: _visibleMonth,
            selectedDate: _selected,
            onDateSelected: _selectDate,
          ),
          SizedBox(height: 20.h),
          CalendarActions(
            onCancel: () => Navigator.pop(context),
            onConfirm: () => Navigator.pop(context, _selected),
          ),
        ],
      ),
    );
  }
}
