import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';

import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF95CCA9),
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  "Welcome ${controller.username}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Obx(
                () => Text(controller.email.value,
                    style: const TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 20),

              // Reactive stats cards
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(controller.userCount.value.toString(),
                          'Users', Colors.green[100]!),
                      _buildStatCard(controller.productCount.value.toString(),
                          'Products', Colors.blue[100]!),
                    ],
                  )),
              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(controller.orderCount.value.toString(),
                          'Orders', Colors.orange[100]!),
                      _buildStatCard(controller.categoryCount.value.toString(),
                          'Categories', Colors.pink[100]!),
                    ],
                  )),
              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(controller.paymentCount.value.toString(),
                          'Payments', Colors.yellow[100]!),
                      _buildStatCard(controller.bannerCount.value.toString(),
                          'Banners', Colors.grey[100]!),
                    ],
                  )),
              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(controller.brandCount.value.toString(),
                          'Brands', Colors.purple[100]!),
                    ],
                  )),
              const SizedBox(height: 20),

              // Order List Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order List',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/order-list');
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Reactive Order List
              Obx(() => ListView.builder(
                    shrinkWrap:
                        true, // Ensure the ListView takes only the required height
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevent scrolling
                    itemCount: controller.recentOrders.length,
                    itemBuilder: (context, index) {
                      final order = controller.recentOrders[index];
                      return _buildOrderRow(index, order.name!, order.status!);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String count, String label, Color backgroundColor) {
    return Container(
      width: 150,
      height: 90,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(count,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(label,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderRow(int index, String customerName, String paymentStatus) {
    return Container(
      color: index % 2 == 0 ? Colors.grey[100] : Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text((index + 1).toString()), // Adding 1 to make index start from 1
          Text(customerName),
          Text(paymentStatus),
        ],
      ),
    );
  }
}
