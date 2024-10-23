import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';

import '../controllers/order_list_controller.dart';

class OrderListView extends GetView<OrderListController> {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders List'),
        backgroundColor: const Color(0xFF95CCA9),
        actions: const [],
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar and Add Order Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.searchOrders(value); // Call search on change
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search Orders',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: const Color(0xFFF4F5F7),
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Order Table
            Obx(() {
              return controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Order Name')),
                              DataColumn(label: Text('Payment')),
                              DataColumn(label: Text('Phone')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: List.generate(
                              controller.filteredList
                                  .length, // Change to filteredList
                              (index) {
                                final orderitem =
                                    controller.filteredList[index];
                                return DataRow(
                                  cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(Text(orderitem.name!)),
                                    DataCell(Text(orderitem.paymentMethod!)),
                                    DataCell(Text(orderitem.phoneNumber!)),
                                    DataCell(Text(orderitem.status!)),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: Colors.blue),
                                            onPressed: () {
                                              Get.toNamed(
                                                  '/order-history-detail',
                                                  arguments: orderitem);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.check,
                                                color: Colors.green),
                                            onPressed: () {
                                              controller.showConfirmDialog(
                                                  orderitem.orderId!);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              // Delete action
                                              controller.deleteorder(
                                                  orderitem.orderId!);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
