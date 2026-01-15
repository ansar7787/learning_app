import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_app/controllers/onboarding_controller.dart';
import 'package:learning_app/views/screens/onboarding/widgets/onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const Color _primaryColor = Color(0xFF00AEB3);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: _primaryColor,
      body: Stack(
        children: [
          /// ---------------- PAGE VIEW ----------------
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.updatePage,
            itemCount: controller.totalPages,
            itemBuilder: (context, index) {
              return OnboardingPage(index: index, controller: controller);
            },
          ),

          /// ---------------- FIXED DOTS ----------------
          Positioned(
            bottom: 170,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.totalPages,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _dot(isActive: controller.currentPage.value == i),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isActive ? 10 : 6,
      height: isActive ? 10 : 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? _primaryColor : Colors.grey.shade300,
      ),
    );
  }
}
