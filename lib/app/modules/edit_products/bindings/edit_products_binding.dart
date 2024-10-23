import 'package:get/get.dart';

import '../controllers/edit_products_controller.dart';

class EditProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProductsController>(
      () => EditProductsController(),
    );
  }
}
