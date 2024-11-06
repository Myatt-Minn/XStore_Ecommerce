import 'package:get/get.dart';

import '../controllers/send_specific_notification_controller.dart';

class SendSpecificNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendSpecificNotificationController>(
      () => SendSpecificNotificationController(),
    );
  }
}
