import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:learning_app/controllers/onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  final int index;
  final OnboardingController controller;

  const OnboardingPage({
    required this.index,
    required this.controller,
    super.key,
  });

  static const Color _primaryColor = Color(0xFF00AEB3);

  @override
  Widget build(BuildContext context) {
    final bool isLast = index == controller.totalPages - 1;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    return ClipRect(
      child: Stack(
        children: [
          /// ---------------- TOP IMAGE ----------------
          Positioned.fill(
            child: Column(
              children: [
                Expanded(child: _buildImage(index)),
                const SizedBox(height: 300),
              ],
            ),
          ),

          /// ---------------- BOTTOM WHITE ARC ----------------
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 240,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  /// Big white circle (arc)
                  Positioned(
                    top: -140,
                    child: Container(
                      width: screenWidth * 1.6,
                      height: screenWidth * 1.6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  /// ---------------- CONTENT ----------------
                  Positioned.fill(
                    top: -100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 16),

                          Text(
                            _getTitleForPage(index),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text(
                            _getDescriptionForPage(index),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 60),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: controller.nextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Text(
                                isLast ? 'Get Started' : 'Next',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: controller.skip,
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 16,
                                color: _primaryColor,
                              ),
                            ),
                          ),

                          SizedBox(height: bottomSafe),
                        ],
                      ),
                    ),
                  ),

                  /// ---------------- FLOATING ICON ----------------
                  Positioned(
                    top: -170,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _primaryColor,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.auto_stories,
                        color: Colors.white,
                        size: 32,
                      ),
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

  /// ---------------- IMAGE ----------------
  Widget _buildImage(int index) {
    final String imagePath = _getImageForPage(index);

    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.fitWidth,
        width: double.infinity,
        placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
        errorWidget: (_, _, _) => const Icon(Icons.broken_image),
      );
    }

    return Image.asset(imagePath, fit: BoxFit.fitWidth, width: double.infinity);
  }

  String _getImageForPage(int index) {
    return index == 0
        ? 'assets/images/onboarding1.jpg'
        : 'assets/images/onboarding2.jpg';
  }

  String _getTitleForPage(int index) {
    return index == 0
        ? 'Smarter Learning\nStarts Here'
        : 'Learn. Practice.\nSucceed.';
  }

  String _getDescriptionForPage(int index) {
    return index == 0
        ? 'Personalized lessons that adapt to\nyour pace and goals.'
        : 'Track your progress, complete\nchallenges, and achieve your goals.';
  }
}
