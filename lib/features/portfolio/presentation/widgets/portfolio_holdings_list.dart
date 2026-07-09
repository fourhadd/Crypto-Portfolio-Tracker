// features/portfolio/presentation/widgets/portfolio_holdings_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

import '../../domain/entities/portfolio_coin_entity.dart';
import 'portfolio_holding_tile.dart';

class PortfolioHoldingsList extends StatelessWidget {
  final List<PortfolioCoinEntity> items;

  const PortfolioHoldingsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length + 1,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return const _AddHoldingButton();
        }
        return PortfolioHoldingTile(
          key: ValueKey(items[index].holding.id),
          item: items[index],
        );
      },
    );
  }
}

class _AddHoldingButton extends StatelessWidget {
  const _AddHoldingButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/portfolio/add'),
      borderRadius: BorderRadius.circular(16.r),
      child: CustomPaint(
        painter: _DashedRectPainter(
          color: AppColors.accentAmber.withValues(alpha: 0.3),
          strokeWidth: 1.2,
          gap: 4.0,
          dashWidth: 8.0,
          radius: 16.r,
        ),
        child: Container(
          height: 68.h,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.accentAmber, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Add Holding',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.accentAmber,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashWidth;
  final double radius;

  _DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.dashWidth = 5.0,
    this.radius = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final dashPath = Path();
    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
