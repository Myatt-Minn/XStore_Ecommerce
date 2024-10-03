import 'package:get/get.dart';

class NavigationScreenController extends GetxController {
  //TODO: Implement NavigationScreenController
  var selectedIndex = 0.obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
