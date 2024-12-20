import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';
import 'package:xstore/app/modules/home/controllers/home_controller.dart';
import 'package:xstore/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';

import '../controllers/order_success_controller.dart';

class OrderSuccessView extends GetView<OrderSuccessController> {
  const OrderSuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title:
            const Text('Order Success', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: ConstsConfig.primarycolor, width: 3.0),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: ConstsConfig.primarycolor,
                  size: 80,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Your order is successfully placed.\nThank you for shopping with us.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  backgroundColor: ConstsConfig.secondarycolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Navigate to shopping or home
                  Get.find<CartController>().clearCart();
                  Get.find<CartController>().totalAmount.value = 0;
                  Get.find<HomeController>().fetchProducts();
                  Get.find<HomeController>().fetchPopular();
                  Get.find<NavigationScreenController>().currentIndex.value = 0;

                  Get.back();
                },
                child: const Text(
                  'Back to Shopping',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
