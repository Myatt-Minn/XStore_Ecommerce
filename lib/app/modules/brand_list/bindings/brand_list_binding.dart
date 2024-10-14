import 'package:get/get.dart';

import '../controllers/brand_list_controller.dart';

class BrandListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrandListController>(
      () => BrandListController(),
    );
  }
}
