import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/modules/admin_dashboard/views/widgets/orderRow.dart';
import 'package:xstore/app/modules/admin_dashboard/views/widgets/statCard.dart';

import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstsConfig.primarycolor,
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

              // Import the StatCard widget

// Reactive stats cards
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatCard(
                        count: controller.userCount.value.toString(),
                        label: 'Users',
                        backgroundColor: ConstsConfig.primarycolor,
                      ),
                      StatCard(
                        count: controller.productCount.value.toString(),
                        label: 'Products',
                        backgroundColor: Colors.blue[100]!,
                      ),
                    ],
                  )),
              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatCard(
                        count: controller.orderCount.value.toString(),
                        label: 'Orders',
                        backgroundColor: Colors.orange[100]!,
                      ),
                      StatCard(
                        count: controller.categoryCount.value.toString(),
                        label: 'Categories',
                        backgroundColor: Colors.pink[100]!,
                      ),
                    ],
                  )),
              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatCard(
                        count: controller.paymentCount.value.toString(),
                        label: 'Payments',
                        backgroundColor: Colors.yellow[100]!,
                      ),
                      StatCard(
                        count: controller.bannerCount.value.toString(),
                        label: 'Banners',
                        backgroundColor: Colors.grey[100]!,
                      ),
                    ],
                  )),

              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatCard(
                          count: controller.brandCount.value.toString(),
                          label: 'Brands',
                          backgroundColor: Colors.purple[100]!),
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
                      return OrderRow(
                        index: index,
                        customerName: order.name!,
                        paymentStatus: order.status!,
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
