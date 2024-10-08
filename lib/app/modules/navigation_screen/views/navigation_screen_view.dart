import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/Cart/views/cart_view.dart';
import 'package:xstore/app/modules/account/views/account_view.dart';
import 'package:xstore/app/modules/category/views/category_view.dart';
import 'package:xstore/app/modules/home/views/home_view.dart';

import '../controllers/navigation_screen_controller.dart';

class NavigationScreenView extends GetView<NavigationScreenController> {
  const NavigationScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const CategoryView(),
      const CartView(),
      const AccountView(),
    ];
    return Scaffold(
      // Using Obx to reactively update the selected screen
      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => CurvedNavigationBar(
          index: controller.selectedIndex.value, // Track current index
          color: const Color(0xFF2E394D),
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: const Color(0xFF95CCA9),
          height: 60,
          items: [
            controller.selectedIndex.value == 0
                ? const Icon(Icons.home, size: 30, color: Colors.white)
                : const Icon(Icons.home_outlined, size: 30, color: Colors.grey),
            controller.selectedIndex.value == 1
                ? const Icon(Icons.favorite, size: 30, color: Colors.white)
                : const Icon(Icons.favorite_border,
                    size: 30, color: Colors.grey),
            controller.selectedIndex.value == 2
                ? const Icon(Icons.shopping_cart, size: 30, color: Colors.white)
                : const Icon(Icons.shopping_cart_outlined,
                    size: 30, color: Colors.grey),
            controller.selectedIndex.value == 3
                ? const Icon(Icons.person, size: 30, color: Colors.white)
                : const Icon(Icons.person_outline,
                    size: 30, color: Colors.grey),
          ],
          onTap: (index) {
            controller.onItemTapped(index); // Change index on tap
          },
          animationDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
