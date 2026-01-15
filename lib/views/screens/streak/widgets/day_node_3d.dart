import 'package:flutter/material.dart';
import '../../../../data/models/streak_model.dart';

class DayNode3D extends StatelessWidget {
  final StreakDay day;

  const DayNode3D({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    // Colors from image: Cyan/Teal
    const topColor = Color(0xFF00ACC1);
    const sideColor = Color(0xFF00838F); // Darker shadow

    return SizedBox(
      width: 80,
      height: 70, // Slightly flattened perspective
      child: Stack(
        children: [
          // Shadow/Bottom depth
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                color: sideColor.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
          // Deep 3D part
          Positioned(
            top: 4,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: sideColor,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          // Top Face
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 6, // Shows the depth below
            child: Container(
              decoration: BoxDecoration(
                color: topColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ), // BOLD WHITE BORDER
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Day',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
