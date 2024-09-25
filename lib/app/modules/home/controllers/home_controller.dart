import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  var currentBanner = 0.obs;

// Function to change the current page
  void changePage(int value) {
    currentBanner.value = value;
  }
}
