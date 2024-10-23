import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';

import '../controllers/order_success_controller.dart';

class OrderSuccessView extends GetView<OrderSuccessController> {
  const OrderSuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Order Success', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
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
                  border: Border.all(color: Colors.green.shade200, width: 3.0),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Your order is successfully placed.\nThank you for shopping with us.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  backgroundColor: Colors.green.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Navigate to shopping or home
                  Get.find<CartController>().cartItems.clear();
                  Get.find<CartController>().totalAmount.value = 0;
                  Get.offAndToNamed('/navigation-screen');
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
