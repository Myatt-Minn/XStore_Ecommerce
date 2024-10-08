import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/order_history/views/widgets/orderlisttile.dart';

import '../controllers/order_history_controller.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  const OrderHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Order History', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orderList.isEmpty) {
          return const Center(child: Text('No orders found'));
        }

        return ListView.separated(
          itemCount: controller.orderList.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          separatorBuilder: (context, index) =>
              const Divider(height: 1, thickness: 1, color: Colors.grey),
          itemBuilder: (context, index) {
            final order = controller.orderList[index];
            return OrderHistoryTile(order: order);
          },
        );
      }),
    );
  }
}
