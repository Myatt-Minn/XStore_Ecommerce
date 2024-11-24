import 'package:get/get.dart';

import '../controllers/delivery_fees_list_controller.dart';

class DeliveryFeesListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryFeesListController>(
      () => DeliveryFeesListController(),
    );
  }
}
