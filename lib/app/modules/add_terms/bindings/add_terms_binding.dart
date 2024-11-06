import 'package:get/get.dart';

import '../controllers/add_terms_controller.dart';

class AddTermsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTermsController>(
      () => AddTermsController(),
    );
  }
}
