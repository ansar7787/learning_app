import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_constants.dart';
import '../services/storage_service.dart';

class OnboardingController extends GetxController {
  final int totalPages = 2;
  final RxInt currentPage = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last page - go to home
      _completeOnboarding();
    }
  }

  void skip() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    StorageService.setOnboardingComplete();
    Get.offNamed(AppConstants.homeRoute);
  }

  void updatePage(int page) {
    currentPage.value = page;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
