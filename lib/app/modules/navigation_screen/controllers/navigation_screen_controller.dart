import 'package:get/get.dart';

class NavigationScreenController extends GetxController {
  //TODO: Implement NavigationScreenController
  var selectedIndex = 0.obs;
  final count = 0.obs;



  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
