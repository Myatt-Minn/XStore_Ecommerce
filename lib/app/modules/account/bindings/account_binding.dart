import 'package:get/get.dart';

import '../controllers/account_controller.dart';

class AcountBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountController(), permanent: true);
  }
}
