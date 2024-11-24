import 'package:get/get.dart';

import '../controllers/add_delivery_fee_controller.dart';

class AddDeliveryFeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDeliveryFeeController>(
      () => AddDeliveryFeeController(),
    );
  }
}
