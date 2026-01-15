import 'package:flutter/material.dart';

class TooltipBubble extends StatelessWidget {
  final double width;
  final double tailX;

  const TooltipBubble({super.key, this.width = 160, required this.tailX});

  @override
  Widget build(BuildContext context) {
    // Top Bubble pointing DOWN
    return CustomPaint(
      painter: BubblePainter(color: const Color(0xFF00ACC1), tailX: tailX),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          20,
        ), // More bottom padding for tail
        width: width,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center text
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Today's Topic",
              style: TextStyle(color: Colors.white70, fontSize: 10),
            ),
            SizedBox(height: 4),
            Text(
              "Core Module",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Divider(color: Colors.white54, height: 12, thickness: 1),
            Text(
              "Core Module",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final Color color;
  final double tailX;

  BubblePainter({required this.color, required this.tailX});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    final r = 16.0;
    final tailHeight = 10.0;
    final tailWidth = 16.0;

    // Body Rect (minus tail height at bottom)
    final rect = Rect.fromLTWH(0, 0, size.width, size.height - tailHeight);
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)));

    // Tail pointing DOWN at dynamic tailX
    final tailPath = Path();
    // Clamp tailX so it doesn't detach from bubble body
    double safeTailX = tailX.clamp(
      r + tailWidth / 2,
      size.width - r - tailWidth / 2,
    );

    tailPath.moveTo(
      safeTailX - tailWidth / 2,
      size.height - tailHeight,
    ); // Left base
    tailPath.lineTo(safeTailX, size.height); // Tip
    tailPath.lineTo(
      safeTailX + tailWidth / 2,
      size.height - tailHeight,
    ); // Right base

    path.addPath(tailPath, Offset.zero);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
