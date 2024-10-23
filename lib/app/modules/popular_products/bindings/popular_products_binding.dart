import 'package:get/get.dart';

import '../controllers/popular_products_controller.dart';

class PopularProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PopularProductsController>(
      () => PopularProductsController(),
    );
  }
}
