import 'package:get/get.dart';
import 'package:xstore/app/data/sendNotificationHandler.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';
import 'package:xstore/app/modules/account/controllers/account_controller.dart';
import 'package:xstore/app/modules/category/controllers/category_controller.dart';
import 'package:xstore/app/modules/home/controllers/home_controller.dart';

class NavigationScreenController extends GetxController {
  //TODO: Implement NavigationScreenController
  var currentIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    initializeController(currentIndex.value);
    await SendNotificationHandler().initNotification();
  }

  void initializeController(int index) {
    // Initialize the corresponding controller based on the selected index
    switch (index) {
      case 0:
        Get.put(HomeController());
        break;
      case 1:
        Get.put(CategoryController());
        break;
      case 2:
        Get.put(CartController());
        break;
      case 3:
        Get.put(AccountController());
        break;
    }
  }

  void disposeController(int index) {
    // Delete the controller from memory when navigating away
    switch (index) {
      case 0:
        Get.delete<HomeController>();
        break;
      case 1:
        Get.delete<CategoryController>();
        break;
      case 2:
        Get.delete<CartController>();
        break;
    }
  }
}
