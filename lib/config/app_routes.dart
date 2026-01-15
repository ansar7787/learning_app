import 'package:get/get.dart';

import '../bindings/home_binding.dart';
import '../bindings/video_binding.dart';
import '../views/screens/onboarding/pages/onboarding_screen.dart';
import '../views/screens/home/pages/home_screen.dart';
import '../views/screens/course/pages/video_screen.dart';
import '../views/screens/streak/pages/streak_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/onboarding', page: () => const OnboardingScreen()),

    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/video',
      page: () => const VideoScreen(),
      binding: VideoBinding(),
    ),
    GetPage(name: '/streak', page: () => const StreakScreen()),
  ];
}
