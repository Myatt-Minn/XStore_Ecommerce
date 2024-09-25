import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController
  //TODO: Implement SplashController

  final box = GetStorage();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(seconds: 3), () {
      checkFirstTime();
    });
  }

  void checkFirstTime() async {
    final bool? repeat = box.read('repeat');
    if (repeat == null) {
      await box.write('repeat', true);
      Get.offAllNamed('/onboarding');
    } else {
      Get.offAllNamed('/auth-gate');
    }
  }
}
