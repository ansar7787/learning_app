import 'package:get/get.dart';
import '../data/models/streak_model.dart';
import '../services/api_service.dart';

class StreakController extends GetxController {
  final days = <StreakDay>[].obs;
  final isLoading = true.obs;
  final currentDay = 0.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStreak();
  }

  Future<void> fetchStreak() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final streakModel = await ApiService.getStreakData();

      currentDay.value = streakModel.currentDay;
      days.assignAll(streakModel.days);
    } catch (e) {
      errorMessage.value = 'Error: $e';
      // print('Error fetching streak: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
