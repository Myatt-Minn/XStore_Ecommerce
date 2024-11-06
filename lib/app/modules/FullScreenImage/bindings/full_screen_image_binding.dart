import 'package:get/get.dart';

import '../controllers/full_screen_image_controller.dart';

class FullScreenImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FullScreenImageController>(
      () => FullScreenImageController(),
    );
  }
}
