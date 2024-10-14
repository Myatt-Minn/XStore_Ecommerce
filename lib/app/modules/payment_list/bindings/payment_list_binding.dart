import 'package:get/get.dart';

import '../controllers/payment_list_controller.dart';

class PaymentListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentListController>(
      () => PaymentListController(),
    );
  }
}
