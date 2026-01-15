import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/home_controller.dart';
import '../widgets/header.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/active_course.dart';
import '../widgets/popular_courses.dart';
import '../widgets/live_class.dart';
import '../widgets/community_card.dart';
import '../widgets/testimonials.dart';
import '../widgets/help_section.dart';
import '../widgets/bottom_nav.dart';

/// ---------------- HOME SCREEN ----------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: controller.fetchHomeData,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final user = controller.user.value;
        if (user == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header and Banner Stack for scrolling overlap
              Stack(
                children: [
                  HomeHeader(controller),
                  Padding(
                    padding: const EdgeInsets.only(top: 130), // Overlap
                    child: const BannerCarousel(),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              ActiveCourse(controller),
              const SizedBox(height: 20),
              PopularCourses(controller),
              const SizedBox(height: 20),
              const LiveClass(),
              const SizedBox(height: 20),
              const CommunityCard(),
              const SizedBox(height: 20),
              const Testimonials(),
              const SizedBox(height: 20),
              const HelpSection(),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),

      bottomNavigationBar: const BottomNav(),
    );
  }
}
