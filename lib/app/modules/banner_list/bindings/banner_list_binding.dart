import 'package:get/get.dart';

import '../controllers/banner_list_controller.dart';

class BannerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BannerListController>(
      () => BannerListController(),
    );
  }
}
