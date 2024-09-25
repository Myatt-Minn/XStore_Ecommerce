import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/content_model.dart';

class OnboardingController extends GetxController {
  //TODO: Implement OnboardingController
// Reactive state for current page
  var currentPage = 0.obs;

  // PageController for the PageView
  late PageController pageController;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose(); // Disposing of the controller
    super.onClose();
  }

  // Function to change the current page
  void changePage(int value) {
    currentPage.value = value;
  }

  // Function to handle the next button tap
  void handleNext() {
    if (currentPage.value == contents.length - 1) {
      Get.offAllNamed('/signup');
    } else {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);
    }
  }
}
