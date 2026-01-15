import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../../../controllers/streak_controller.dart';
import '../widgets/day_node_3d.dart';
import '../widgets/tooltip_bubble.dart';
import '../widgets/dashed_curve_painter.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  static const double itemHeight = 220.0; // Increased to prevent bubble overlap
  static const double amplitude = 120.0; // Much wider curves for zig-zag effect

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StreakController());

    return Scaffold(
      backgroundColor: const Color(0xFFB2EBF2), // Light cyan background base
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80DEEA), Color(0xFF4DD0E1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background Decorations (Stars)
            const Positioned(top: 50, right: 30, child: _StarIcon()),
            const Positioned(
              top: 150,
              left: 40,
              child: _StarIcon(size: 20, opacity: 0.6),
            ),
            const Positioned(top: 300, right: 80, child: _StarIcon(size: 25)),
            const Positioned(bottom: 200, left: 20, child: _StarIcon(size: 40)),
            const Positioned(bottom: 100, right: 50, child: _StarIcon()),

            // Main Content
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.fetchStreak,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              final days = controller.days;
              if (days.isEmpty) {
                return const Center(
                  child: Text(
                    "No streak data available",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final totalHeight = days.length * itemHeight + 200;

              return SingleChildScrollView(
                child: SizedBox(
                  height: totalHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Path Layer
                      CustomPaint(
                        size: Size(
                          MediaQuery.of(context).size.width,
                          totalHeight,
                        ),
                        painter: DashedCurvePainter(
                          days.length,
                          itemHeight,
                          amplitude,
                        ),
                      ),
                      // Nodes Layer
                      ...List.generate(days.length, (index) {
                        final day = days[index];
                        final center = MediaQuery.of(context).size.width / 2;
                        // Invert index visually (Day 1 at bottom)
                        final visualIndex = (days.length - 1) - index;
                        final y = visualIndex * itemHeight + 100.0;
                        final xOffset = math.sin(visualIndex * 1.5) * amplitude;
                        final x = center + xOffset;

                        return Positioned(
                          left: x - 40, // Width 80
                          top: y,
                          child: DayNode3D(day: day),
                        );
                      }),

                      // Today's Topic Bubble
                      ...days.asMap().entries.where((e) => e.value.isToday).map(
                        (e) {
                          final index = e.key;
                          final visualIndex = (days.length - 1) - index;
                          final y = visualIndex * itemHeight + 100.0;
                          final xOffset =
                              math.sin(visualIndex * 1.5) * amplitude;
                          final screenWidth = MediaQuery.of(context).size.width;
                          final center = screenWidth / 2;
                          final nodeX = center + xOffset;

                          // Bubble logic
                          const double bubbleWidth = 160.0;
                          const double padding = 16.0;

                          // Ideal left is centered on node
                          double left = nodeX - (bubbleWidth / 2);

                          // Clamp to screen
                          if (left < padding) left = padding;
                          if (left + bubbleWidth > screenWidth - padding) {
                            left = screenWidth - bubbleWidth - padding;
                          }

                          // Calculate local tail X relative to bubble
                          // nodeX is absolute. left is absolute.
                          // local X = nodeX - left
                          double tailX = nodeX - left;

                          return Positioned(
                            top: y - 110,
                            left: left,
                            child: TooltipBubble(
                              width: bubbleWidth,
                              tailX: tailX,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StarIcon extends StatelessWidget {
  final double size;
  final double opacity;

  const _StarIcon({this.size = 30, this.opacity = 0.4});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Icon(
        Icons.star,
        color: Colors.white.withValues(alpha: opacity),
        size: size,
      ),
    );
  }
}
