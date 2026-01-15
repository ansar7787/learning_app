import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class DashedCurvePainter extends CustomPainter {
  final int count;
  final double itemHeight;
  final double amplitude;

  DashedCurvePainter(this.count, this.itemHeight, this.amplitude);

  @override
  void paint(Canvas canvas, Size size) {
    if (count == 0) return;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Thinner line

    final path = Path();
    final centerX = size.width / 2;

    // Build the full curve first
    // Start from top (visualIndex 0)

    for (int i = 0; i < count; i++) {
      final visualIndex = i;
      final y = visualIndex * itemHeight + 100.0 + 35;
      final xOffset =
          math.sin(visualIndex * 1.5) * amplitude; // Match new frequency
      final x = centerX + xOffset;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevY = (i - 1) * itemHeight + 100.0 + 35;
        final prevXOffset = math.sin((i - 1) * 1.5) * amplitude;
        final prevX = centerX + prevXOffset;

        final p1x = prevX;
        final p1y = prevY + itemHeight / 2;
        final p2x = x;
        final p2y = y - itemHeight / 2;

        path.cubicTo(p1x, p1y, p2x, p2y, x, y);
      }
    }

    // Dotted effect
    final dashPath = Path();
    double dashWidth = 4.0; // Smaller dots
    double dashSpace = 6.0; // More space
    double distance = 0.0;

    for (PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        dashPath.addPath(
          measurePath.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
