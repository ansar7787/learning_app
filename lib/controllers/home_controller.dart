import 'package:get/get.dart';
import '../services/api_service.dart';
import '../data/models/home_model.dart';

class HomeController extends GetxController {
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  // Observables for UI
  final user = Rxn<User>();
  final banners = <BannerItem>[].obs;
  final activeCourse = Rxn<ActiveCourse>();
  final popularCourses = <CourseCategory>[].obs;
  final liveSession = Rxn<LiveSession>();

  final selectedCategoryIndex = 0.obs;
  final currentBannerIndex = 0.obs;

  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  void fetchHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final homeResponse = await ApiService.getHomeData();

      user.value = homeResponse.user;
      banners.assignAll(homeResponse.heroBanners);
      activeCourse.value = homeResponse.activeCourse;

      // Manual injection of missing categories for UI completeness
      final fetchedCategories = homeResponse.popularCourses;
      final requiredCategories = ["KTET", "HST", "CUET", "LPST", "General PSC"];

      // Add missing categories as empty placeholders if not present
      for (var catName in requiredCategories) {
        if (!fetchedCategories.any((c) => c.name == catName)) {
          fetchedCategories.add(
            CourseCategory(id: 0, name: catName, courses: []),
          );
        }
      }

      popularCourses.assignAll(fetchedCategories);
      liveSession.value = homeResponse.liveSession;

      // Fetch real streak to ensure sync
      try {
        final streakData = await ApiService.getStreakData();
        final realStreak = streakData.currentDay;

        // Re-create user with updated streak
        if (user.value != null) {
          user.value = User(
            name: homeResponse.user.name,
            greeting: homeResponse.user.greeting,
            streakDays: realStreak,
          );
        }
      } catch (e) {
        // print("Streak fetch failed: $e");
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
  }

  void goToStreak() {
    Get.toNamed('/streak');
  }
}
