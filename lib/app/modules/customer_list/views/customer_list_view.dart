import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';

import '../controllers/customer_list_controller.dart';

class CustomerListView extends GetView<CustomerListController> {
  const CustomerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        backgroundColor: const Color(0xFF95CCA9),
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.searchUsers(value); // Call search on change
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search users',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: const Color(0xFFF4F5F7),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
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
                              DataColumn(label: Text('User')),
                              DataColumn(label: Text('User Name')),
                              DataColumn(label: Text('User Email')),
                              DataColumn(label: Text('User Role')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: List.generate(
                              controller.filteredList
                                  .length, // Change to filteredList
                              (index) {
                                final useritem = controller.filteredList[index];
                                return DataRow(
                                  cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(
                                      FancyShimmerImage(
                                        imageUrl: useritem
                                            .profilepic, // Replace with your user image URL
                                        width: 50,
                                        height: 50,
                                        errorWidget: const Icon(Icons.error),
                                      ),
                                    ),
                                    DataCell(Text(useritem.name)),
                                    DataCell(Text(useritem.email)),
                                    DataCell(Text(useritem.role)),
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
