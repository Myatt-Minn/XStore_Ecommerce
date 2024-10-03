import 'package:get/get.dart';

import '../controllers/navigation_screen_controller.dart';

class NavigationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationScreenController>(
      () => NavigationScreenController(),
    );
  }
}
