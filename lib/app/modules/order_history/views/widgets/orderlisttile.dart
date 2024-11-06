import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/data/order_model.dart';

class OrderHistoryTile extends StatelessWidget {
  final OrderItem order;

  const OrderHistoryTile({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return ConstsConfig.primarycolor;
      case 'Refund':
        return Colors.blue;
      case 'Cancel':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Get.isDarkMode ? Colors.white : Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      title: Text(
        'ID: ${order.orderId}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(order.totalPrice.toString(),
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 5),
          Text('Date: ${order.orderDate}',
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            order.status!,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(order.status!)),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: () {
        // Handle tap event to navigate to order detail page
        Get.toNamed('/order-history-detail', arguments: order);
      },
    );
  }
}
