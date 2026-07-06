// core/shared/widgets/glass_shimmer.dart
// shared/widgets/glass_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GlassShimmer extends StatelessWidget {
  final Widget child;

  const GlassShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
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
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.05),
      highlightColor: Colors.white.withValues(alpha: 0.15),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape,
          borderRadius: shape == BoxShape.circle
              ? null
              : BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
