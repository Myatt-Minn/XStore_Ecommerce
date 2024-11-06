import 'package:get/get.dart';

import '../controllers/all_category_products_controller.dart';

class AllCategoryProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllCategoryProductsController>(
      () => AllCategoryProductsController(),
    );
  }
}
