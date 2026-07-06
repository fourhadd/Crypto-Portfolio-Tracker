// shared/widgets/glass_shimmer.dart

import 'package:flutter/material.dart';

class GlassShimmer extends StatefulWidget {
  final Widget child;

  const GlassShimmer({super.key, required this.child});

  @override
  State<GlassShimmer> createState() => _GlassShimmerState();
}

class _GlassShimmerState extends State<GlassShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: CustomPaint(
                  painter: _GlassShimmerPainter(_controller.value),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlassShimmerPainter extends CustomPainter {
  final double animationValue;

  _GlassShimmerPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = _createGradient(size).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, paint);
  }

  LinearGradient _createGradient(Size size) {
    double startPoint = -1.0 + animationValue * 2.0;

    return LinearGradient(
      begin: const Alignment(-1.0, 1.0),
      end: const Alignment(1.0, -1.0),
      stops: [0.0, startPoint - 0.2, startPoint, startPoint + 0.2, 1.0],
      colors: [
        Colors.transparent,
        Colors.white.withValues(alpha: 0.0),
        const Color(0xFFC0C0C0).withValues(alpha: 0.18),
        const Color(0xFFE6E6FA).withValues(alpha: 0.15),
        Colors.white.withValues(alpha: 0.0),
      ],
    );
  }

  @override
  bool shouldRepaint(_GlassShimmerPainter oldDelegate) => true;
}

class ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const ShimmerBlock({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius),
      ),
    );
  }
}
