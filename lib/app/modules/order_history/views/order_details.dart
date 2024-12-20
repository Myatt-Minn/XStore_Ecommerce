import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/order_model.dart';

import '../controllers/order_history_controller.dart';

class OrderDetails extends GetView<OrderHistoryController> {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the passed OrderItem object from arguments
    final OrderItem order = Get.arguments as OrderItem;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History Detail',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(order),
            const SizedBox(height: 16),
            _buildItemDetails(order),
            const SizedBox(height: 16),
            order.paymentMethod!.isEmpty
                ? Container()
                : _buildPaymentType(order),
            const SizedBox(height: 16),
            order.transationUrl!.isEmpty
                ? Container()
                : _buildTransitionImage(order),
            const SizedBox(height: 16),
            _buildCustomerInfo(order),
            const SizedBox(height: 16),
            _buildCostDetails(order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(OrderItem order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
          Text(
            order.orderId!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            order.totalPrice!.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              order.status!,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              controller.formatDate(order.orderDate!.toString()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemDetails(OrderItem order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: order.items!.map((orderitem) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
            child: Row(
              children: [
                FancyShimmerImage(
                  imageUrl: orderitem.imageUrl,
                  width: 80,
                  height: 50,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 190,
                      child: Text(
                        orderitem.name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Text(
                      "${orderitem.price} MMK",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Text(
                      "Size: ${orderitem.size}",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentType(OrderItem order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Type",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns the start of the text
            children: [
              Text(
                order.paymentMethod!,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransitionImage(OrderItem order) {
    return GestureDetector(
      onTap: () {
        // Navigate to the full-screen image view
        Get.toNamed('/full-screen-image', arguments: order.transationUrl!);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Transition Image",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 8),
            Image.network(
              order.transationUrl!,
              height: 100,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(OrderItem order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Name",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                order.name!,
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Phone Number",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                order.phoneNumber!,
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Address",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                order.address!,
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostDetails(OrderItem order) {
    return Column(
      children: [
        ListTile(
          title: const Text(
            "Subtotal",
            style: TextStyle(fontSize: 16),
          ),
          trailing: Text(
            "${order.totalPrice! - order.deliveryFee!} MMK",
            style: const TextStyle(fontSize: 16),
          ),
        ),
        ListTile(
          title: Text(
            "Delivery Fees",
            style: TextStyle(fontSize: 16),
          ),
          trailing: Text(
            "${order.deliveryFee} MMK",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text(
            "Total Cost",
            style: TextStyle(fontSize: 16),
          ),
          trailing: Text(
            "${order.totalPrice} MMK",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
