import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:xstore/app/modules/Cart/views/cart_view.dart';
import 'package:xstore/app/modules/Wishlist/views/wishlist_view.dart';
import 'package:xstore/app/modules/home/views/home_view.dart';
import 'package:xstore/app/modules/profile/views/profile_view.dart';
import 'package:get/get.dart';

import '../controllers/auth_gate_controller.dart';

class AuthGateView extends GetView<AuthGateController> {
  const AuthGateView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const HomeView(),
      const WishlistView(),
      const CartView(),
      const ProfileView(),
    ];
    return Scaffold(
      // Using Obx to reactively update the selected screen
      body: Obx(() => _pages[controller.selectedIndex.value]),
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
