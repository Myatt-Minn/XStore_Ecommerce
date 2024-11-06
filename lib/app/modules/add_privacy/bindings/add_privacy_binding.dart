import 'package:get/get.dart';

import '../controllers/add_privacy_controller.dart';

class AddPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPrivacyController>(
      () => AddPrivacyController(),
    );
  }
}
