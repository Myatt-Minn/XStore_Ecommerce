import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/Cart/views/cart_view.dart';
import 'package:xstore/app/modules/account/views/account_view.dart';
import 'package:xstore/app/modules/category/views/category_view.dart';
import 'package:xstore/app/modules/home/views/home_view.dart';

import '../controllers/navigation_screen_controller.dart';

class NavigationScreenView extends GetView<NavigationScreenController> {
  final List<Widget> _views = [
    const HomeView(),
    const CategoryView(),
    const CartView(),
    const AccountView(),
  ];

  NavigationScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
          _views[controller.currentIndex.value]), // Display the current view
      bottomNavigationBar: Obx(
        () => CurvedNavigationBar(
          buttonBackgroundColor: const Color(0xFF95CCA9),
          color: const Color(0xFF2E394D),
          backgroundColor: Colors.transparent,
          index: controller.currentIndex.value,
          height: 60.0,
          items: <Widget>[
            Icon(
              Icons.home,
              size: 30,
              color: controller.currentIndex.value == 0
                  ? Colors.black
                  : Colors.white, // Black when selected, white otherwise
            ),
            Icon(
              Icons.category,
              size: 30,
              color: controller.currentIndex.value == 1
                  ? Colors.black
                  : Colors.white, // Black when selected, white otherwise
            ),
            Icon(
              Icons.shopping_cart,
              size: 30,
              color: controller.currentIndex.value == 2
                  ? Colors.black
                  : Colors.white, // Black when selected, white otherwise
            ),
            Icon(
              Icons.person,
              size: 30,
              color: controller.currentIndex.value == 3
                  ? Colors.black
                  : Colors.white, // Black when selected, white otherwise
            ),
          ],
          onTap: (index) {
            // Dispose of the old controller
            controller.disposeController(controller.currentIndex.value);

            // Initialize the new controller
            controller.initializeController(index);

            // Update the current index
            controller.currentIndex.value = index;
          },
        ),
      ),
    );
  }
}
